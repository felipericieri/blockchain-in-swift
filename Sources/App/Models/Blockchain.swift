//
//  Blockchain.swift
//
//  Created by Felipe Ricieri on 26/10/21.
//

import Vapor

/**
 A chain of blocks
 */
final class Blockchain: Content {
  
  enum Error: Swift.Error {
    case invalidBlockHash
  }
  
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
  
  /// Adds a block to the chain
  func add(block: Block) throws {
    guard block.hash != nil else {
      throw Error.invalidBlockHash
    }
    
    blocks.append(block)
  }
  
  /// Registers a node to this chain and returns all nodes registered
  func register(nodes: [Node]) -> [Node] {
    self.nodes.append(contentsOf: nodes)
    return self.nodes
  }
}

// MARK: - Coding Keys

extension Blockchain {
  enum CodingKeys: String, CodingKey {
    case blocks
  }
}
