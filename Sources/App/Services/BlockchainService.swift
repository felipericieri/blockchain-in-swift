//
//  BlockchainService.swift
//
//  Created by Felipe Ricieri on 26/10/21.
//

import Foundation

class BlockchainService {
  
  let blockchain: Blockchain
  
  var nodes: [Node] {
    return blockchain.nodes
  }
  
  init() {
    blockchain = Blockchain(genesisBlock: Block())
  }
  
  func nextBlock(txs: [Transaction]) -> Block {
    let block = blockchain.getNextBlock(with: txs)
    blockchain.addBlock(block)
    return block
  }
  
  func register(nodes: [Node]) -> [Node] {
    let registeredNodes = blockchain.register(nodes: nodes)
    return registeredNodes
  }
}