//
//  File.swift
//  
//
//  Created by Felipe Ricieri on 22/07/2021.
//

import Cocoa
import Vapor

final class Node: Content {
  let addr: String
  init(addr: String) {
    self.addr = addr
  }
}

protocol SmartContract {
  func apply(transaction: Transaction)
}

class TransactionTypeSmartContract: SmartContract {
  func apply(transaction: Transaction) {
    var fees: Double = 0
    switch transaction.transactionType {
    case .some(.domestic):
      fees = 0.02
    case .some(.international):
      fees = 0.05
    case .none:
      fees = 0
    }
    transaction.fees = transaction.amount + fees
  }
}

enum TransactionType: String, Codable {
  case domestic
  case international
}

final class Transaction: Content {
  let from: String
  let to: String
  let amount: Double
  var fees: Double? = 0.0
  let transactionType: TransactionType?
  init(from: String, to: String, amount: Double, transactionType: TransactionType) {
    self.from = from
    self.to = to
    self.amount = amount
    self.transactionType = transactionType
  }
}

final class Block: Content {
  var index: Int = 0
  var previousHash: String = ""
  var hash: String!
  var nonce: Int
  
  var key: String {
    get {
      let transactionsData = try! JSONEncoder().encode(transactions)
      let transactionJsonString = String(data: transactionsData, encoding: .utf8)!
      return String(index) + previousHash + String(nonce) + transactionJsonString
    }
  }
  
  private(set) var transactions: [Transaction] = []
  
  init() {
    self.nonce = 0
  }
  
  func add(_ transaction: Transaction) {
    transactions.append(transaction)
  }
}

final class Blockchain: Content {
  
  private(set) var blocks: [Block] = []
  private(set) var smartContracts: [SmartContract] = [TransactionTypeSmartContract()]
  private(set) var nodes = [Node]()
  
  enum CodingKeys: String, CodingKey {
    case blocks
  }
  
  init(genesisBlock: Block) {
    addBlock(genesisBlock)
  }
  
  func register(nodes: [Node]) -> [Node] {
    self.nodes.append(contentsOf: nodes)
    return self.nodes
  }
  
  func addBlock(_ block: Block) {
    if blocks.isEmpty {
      block.previousHash = "000000000000000000"
      block.hash = generateHash(for: block)
    }
    
    // run the smart contracts
    smartContracts.forEach { contract in
      block.transactions.forEach { tx in
        contract.apply(transaction: tx)
      }
    }
    
    blocks.append(block)
  }
  
  func getNextBlock(with transactions: [Transaction]) -> Block {
    let block = Block()
    transactions.forEach { block.add($0) }
    let previousBlock = getPreviousBlock()
    block.index = blocks.count
    block.previousHash = previousBlock.hash
    block.hash = generateHash(for: block)
    return block
  }
  
  private func getPreviousBlock() -> Block {
    return blocks[blocks.count - 1]
  }
  
  func generateHash(for block: Block) -> String {
    var hash = block.key.sha1Hash()
    
    while !hash.hasPrefix("00") {
      block.nonce += 1
      hash = block.key.sha1Hash()
      print(hash)
    }
    
    return hash
  }
}

// helpers

extension String {
  func sha1Hash() -> String {
      
      let task = Process()
      task.launchPath = "/usr/bin/shasum"
      task.arguments = []
      
      let inputPipe = Pipe()
      
      inputPipe.fileHandleForWriting.write(self.data(using: String.Encoding.utf8)!)
      
      inputPipe.fileHandleForWriting.closeFile()
      
      let outputPipe = Pipe()
      task.standardOutput = outputPipe
      task.standardInput = inputPipe
      task.launch()
      
      let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
      let hash = String(data: data, encoding: String.Encoding.utf8)!
      return hash.replacingOccurrences(of: "  -\n", with: "")
  }
}
