//
//  BlockchainController.swift
//
//  Created by Felipe Ricieri on 26/10/21.
//

import Vapor

/**
 Blockchain Controller - returns the routes to API
 */
class BlockchainController {
  
  /// BLockchain Service
  private let blockchainService: BlockchainService
  
  // MARK: - Initialiser
  
  init() {
    blockchainService = BlockchainService()
  }
  
  // MARK: - Routes
  
  /// Retrieves the blockchain initialised by the node
  func blockchain(req: Request) -> EventLoopFuture<Blockchain> {
    return req.eventLoop.future(blockchainService.blockchain)
  }
  
  /// Mints the next block
  func mine(req: Request) throws -> EventLoopFuture<Block> {
    let txs = try req.content.decode([Transaction].self)
    let block = blockchainService.nextBlock(txs: txs)
    return req.eventLoop.future(block)
  }
  
  /// Returns a collection of registered nodes to the blockchain in this node
  func nodes(req: Request) throws -> EventLoopFuture<[Node]> {
    return req.eventLoop.future(blockchainService.nodes)
  }
  
  /// Registers a node
  func registerNode(req: Request) throws -> EventLoopFuture<[Node]> {
    let givenNodes = try req.content.decode([Node].self)
    let nodes = blockchainService.register(nodes: givenNodes)
    return req.eventLoop.future(nodes)
  }
}
