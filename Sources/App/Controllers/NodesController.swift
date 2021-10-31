//
//  NodesController.swift
//
//  Created by Felipe Ricieri on 31/10/21.
//

import Vapor

/**
 Nodes Controller - returns the routes to API
 */
class NodesController {
  
  /// Nodes Service
  private let blockchainService: BlockchainService
  
  // MARK: - Initialiser
  
  init(blockchainService: BlockchainService) {
    self.blockchainService = blockchainService
  }
  
  // MARK: - Routes
  
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
