//
//  Block.swift
//
//  Created by Felipe Ricieri on 26/10/21.
//

import Vapor

final class Block: Content {
  var index: Int = 0
  var previousHash: String = ""
  var hash: String!
  var nonce: Int
  
  var key: String {
    get {
      let transactionsData = try! JSONEncoder().encode(transactions)
      let transactionJsonString = String(data: transactionsData, encoding: .utf8)!
      return String(index) + previousHash + String(nonce) + transactionJsonString
    }
  }
  
  private(set) var transactions: [Transaction] = []
  
  init() {
    self.nonce = 0
  }
  
  func add(_ transaction: Transaction) {
    transactions.append(transaction)
  }
}
