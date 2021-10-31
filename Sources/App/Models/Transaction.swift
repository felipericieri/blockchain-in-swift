//
//  Transaction.swift
//
//  Created by Felipe Ricieri on 26/10/21.
//

import Vapor

/**
 A fact to be registered
 */
final class Transaction: Content {
  
  /// Sender Name
  let from: String
  
  /// Receiver Name
  let to: String
  
  /// Amount of SWIFT
  let amount: Double

  // MARK: - Initialiser
  
  init(from: String, to: String, amount: Double) {
    self.from = from
    self.to = to
    self.amount = amount
  }
}
