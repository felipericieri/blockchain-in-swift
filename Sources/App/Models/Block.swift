//
//  Block.swift
//
//  Created by Felipe Ricieri on 26/10/21.
//

import Vapor

/**
 Element of the Blockchain
 */
final class Block: Content {
  
  /// The height the block is in the chain
  private(set) var index: UInt
  
  /// Reference to the hash of the previous block
  private(set) var previousHash: String
  
  /// The block hash. It is `nil` until the block is minted
  private(set) var hash: String!
  
  /// Random value that
  private(set) var nonce: UInt
  
  /// Transactions added to the block
  private(set) var transactions: [Transaction]
  
  ///
  var key: String {
    get {
      let transactionsData = try! JSONEncoder().encode(transactions)
      let transactionJsonString = String(data: transactionsData, encoding: .utf8)!
      return String(index) + previousHash + String(nonce) + transactionJsonString
    }
  }
  
  // MARK: -  Initialiser
  
  init() {
    index = 0
    previousHash = ""
    nonce = 0
    transactions = []
  }
  
  // MARK: - Block features
  
  /// Adds a transaction to this block
  func add(_ transaction: Transaction) {
    transactions.append(transaction)
  }
  
  /// Mines this block
  func mine(index: UInt = 0, previousHash: String, hash: String) {
    self.index = index
    self.previousHash = previousHash
    self.hash = hash
  }
  
  /// Increments nonce
  func incrementNonce() {
    nonce += 1
  }
}
