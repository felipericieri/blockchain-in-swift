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
  
  /// Collection of blocks in this chain
  private(set) var blocks: [Block] = []
  
  /// Nodes registered in this chain
  private(set) var nodes = [Node]()
  
  /// Returns latest block in this chain
  var latestBlock: Block {
    return blocks[blocks.count - 1]
  }
  
  // MARK: - Initialiser
  
  init(genesisBlock: Block) {
    blocks.append(genesisBlock)
  }
  
  // MARK: - Blockchain features
  
  /// Registers a node to this chain and returns all nodes registered
  func register(nodes: [Node]) -> [Node] {
    self.nodes.append(contentsOf: nodes)
    return self.nodes
  }
  
  /// Adds a block to the chain
  func add(_ block: Block) {
    blocks.append(block)
  }
}

// MARK: - Coding Keys

extension Blockchain {
  enum CodingKeys: String, CodingKey {
    case blocks
  }
}
