//
//  Blockchain.swift
//
//  Created by Felipe Ricieri on 26/10/21.
//

import Vapor

final class Blockchain: Content {
  
  private(set) var blocks: [Block] = []
//  private(set) var smartContracts: [SmartContract] = [TransactionTypeSmartContract()]
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
//    smartContracts.forEach { contract in
//      block.transactions.forEach { tx in
//        contract.apply(transaction: tx)
//      }
//    }
    
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
