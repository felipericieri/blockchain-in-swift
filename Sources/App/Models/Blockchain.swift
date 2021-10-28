//
//  Blockchain.swift
//
//  Created by Felipe Ricieri on 26/10/21.
//

import Vapor

/**
 Blockchain - acts like a Blocks Controller
 */
final class Blockchain: Content {
  
  /// Difficulty to mine a block
  let difficulty = 2
  
  /// Collection of blocks in this chain
  private(set) var blocks: [Block] = []
  
//  private(set) var smartContracts: [SmartContract] = [TransactionTypeSmartContract()]
  
  /// Nodes registered in this chain
  private(set) var nodes = [Node]()
  
  // MARK: - Initialiser
  
  init(genesisBlock: Block) {
    addBlock(genesisBlock)
  }
  
  // MARK: - Blockchain features
  
  /// Registers a node to this chain and returns all nodes registered
  func register(nodes: [Node]) -> [Node] {
    self.nodes.append(contentsOf: nodes)
    return self.nodes
  }
  
  /// Adds a block to the chain
  func addBlock(_ block: Block) {
    
    if blocks.isEmpty {
      block.mine(
        previousHash: "000000000000000000",
        hash: generateHash(for: block)
      )
    }
    
    // run the smart contracts
//    smartContracts.forEach { contract in
//      block.transactions.forEach { tx in
//        contract.apply(transaction: tx)
//      }
//    }
    
    blocks.append(block)
  }
  
  /// Mine the next block
  func getNextBlock(with transactions: [Transaction]) -> Block {
    let block = Block()
    transactions.forEach { block.add($0) }
    
    block.mine(
      index: UInt(blocks.count),
      previousHash: previousBlock.hash,
      hash: generateHash(for: block)
    )
    
    return block
  }
  
  // MARK: - Private functionality
  
  /// Returns previous block in this chain
  private var previousBlock: Block {
    return blocks[blocks.count - 1]
  }
  
  /// Block hash prefix according to the Blockchain difficulty
  private var prefix: String {
    return ([String](repeating: "0", count: difficulty)).joined(separator: "")
  }
  
  /// Generate Hash for Block according to the difficulty of this blockchain
  private func generateHash(for block: Block) -> String {
    var hash = block.key.sha1Hash()
    
    while !hash.hasPrefix(prefix) {
      block.incrementNonce()
      hash = block.key.sha1Hash()
      print(hash)
    }
    
    return hash
  }
}

// MARK: - Coding Keys

extension Blockchain {
  enum CodingKeys: String, CodingKey {
    case blocks
  }
}
