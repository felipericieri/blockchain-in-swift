//
//  BlockchainService.swift
//
//  Created by Felipe Ricieri on 26/10/21.
//

import Foundation

/// The first block hash every minted
let GENESIS_BLOCK_HASH = 40.zeros

/**
 Exposes the Blockchain to the Controller
 */
class BlockchainService {
  
  /// Difficulty to mine a block
  let difficulty = 2.zeros
    
  /// Current blockchain
  let blockchain: Blockchain
  
  /// Mining Service
  private let miningService: MiningService
  
  /// Nodes registered
  var nodes: [Node] {
    return blockchain.nodes
  }
  
  // MARK: - Initialiser
  
  init() {
    miningService = MiningService(difficulty: difficulty)
    
    // Generates Genesis Block
    let genesisBlock = Block(index: 0, previousHash: GENESIS_BLOCK_HASH)
    genesisBlock.hash = miningService.generateHash(for: genesisBlock)
    
    blockchain = Blockchain(genesisBlock: genesisBlock)
  }
  
  // MARK: - Service features
  
  /// Mintes the next block
  func nextBlock(txs: [Transaction]) throws -> Block {
    let block = miningService.mineBlock(previousBlock: blockchain.latestBlock, transactions: txs)
    try blockchain.add(block)
    return block
  }
  
  /// Register nodes to the blockchain
  func register(nodes: [Node]) -> [Node] {
    let registeredNodes = blockchain.register(nodes: nodes)
    return registeredNodes
  }
}
