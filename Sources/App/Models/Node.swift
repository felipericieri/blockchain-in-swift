//
//  Node.swift
//
//  Created by Felipe Ricieri on 22/07/2021.
//

import Cocoa
import Vapor

final class Node: Content {
  let addr: String
  init(addr: String) {
    self.addr = addr
  }
}
