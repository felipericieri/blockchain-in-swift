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
  let difficulty = 2.zeros
  
  /// Collection of blocks in this chain
  private(set) var blocks: [Block] = []
  
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
      block.genesis(hash: generateHash(for: block))
    }
    
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
  
  /// Generate Hash for Block according to the difficulty of this blockchain
  private func generateHash(for block: Block) -> String {
    var hash = block.key.sha1Hash()
    
    // Search for a hash prefix according to the Blockchain difficulty
    while !hash.hasPrefix(difficulty) {
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
