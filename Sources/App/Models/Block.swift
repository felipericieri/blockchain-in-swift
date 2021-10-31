//
//  Block.swift
//
//  Created by Felipe Ricieri on 26/10/21.
//

import Vapor

/**
 The transactions' cluster
 */
final class Block: Content {
  
  /// The height the block is in the chain
  private(set) var index: UInt
  
  /// Reference to the hash of the previous block
  private(set) var previousHash: String
  
  /// The block hash. It is `nil` until the block is minted
  var hash: String!
  
  /// Random value that
  private(set) var nonce: UInt = 0
  
  /// Transactions added to the block
  private(set) var transactions: [Transaction]
  
  /// The block flatten in a key, so it can be hashed
  var key: String {
    let transactionsData = try! JSONEncoder().encode(transactions)
    let transactionJsonString = String(data: transactionsData, encoding: .utf8)!
    return String(index) + previousHash + String(nonce) + transactionJsonString
  }
  
  // MARK: -  Initialiser
  
  init(index: UInt, previousHash: String) {
    self.index = index
    self.previousHash = previousHash
    self.transactions = []
  }
  
  // MARK: - Block features
  
  /// Adds a transaction to this block
  func add(transaction: Transaction) {
    transactions.append(transaction)
  }
  
  /// Increments nonce
  func incrementNonce() {
    nonce += 1
  }
}
