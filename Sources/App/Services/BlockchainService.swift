//
//  BlockchainService.swift
//
//  Created by Felipe Ricieri on 26/10/21.
//

import Foundation

/**
 Exposes the Blockchain to the Controller
 */
class BlockchainService {
  
  /// Current blockchain
  let blockchain: Blockchain
  
  /// Nodes registered
  var nodes: [Node] {
    return blockchain.nodes
  }
  
  // MARK: - Initialiser
  
  init() {
    blockchain = Blockchain(genesisBlock: Block())
  }
  
  /// Mintes the next block
  func nextBlock(txs: [Transaction]) -> Block {
    let block = blockchain.getNextBlock(with: txs)
    blockchain.addBlock(block)
    return block
  }
  
  /// Register nodes to the blockchain
  func register(nodes: [Node]) -> [Node] {
    let registeredNodes = blockchain.register(nodes: nodes)
    return registeredNodes
  }
}
