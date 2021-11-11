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
  let sender: String
  
  /// Receiver Name
  let receiver: String
  
  /// Amount of SWIFT
  let amount: Double

  // MARK: - Initialiser
  
  init(sender: String, receiver: String, amount: Double) {
    self.sender = sender
    self.receiver = receiver
    self.amount = amount
  }
}
