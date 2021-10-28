//
//  Node.swift
//
//  Created by Felipe Ricieri on 22/07/2021.
//

import Vapor

/**
 Any machine connected to the network
 */
final class Node: Content {
  
  /// Node's address
  let addr: String
  
  // MARK: - Initialiser
  
  init(addr: String) {
    self.addr = addr
  }
}
