//
//  File.swift
//  
//
//  Created by Felipe Ricieri on 26/10/21.
//

import Foundation
import Vapor

enum TransactionType: String, Codable {
  case domestic
  case international
}

final class Transaction: Content {
  let from: String
  let to: String
  let amount: Double
  var fees: Double? = 0.0
  let transactionType: TransactionType?
  init(from: String, to: String, amount: Double, transactionType: TransactionType) {
    self.from = from
    self.to = to
    self.amount = amount
    self.transactionType = transactionType
  }
}

// Example

class TransactionTypeSmartContract: SmartContract {
  func apply(transaction: Transaction) {
    var fees: Double = 0
    switch transaction.transactionType {
    case .some(.domestic):
      fees = 0.02
    case .some(.international):
      fees = 0.05
    case .none:
      fees = 0
    }
    transaction.fees = transaction.amount + fees
  }
}
