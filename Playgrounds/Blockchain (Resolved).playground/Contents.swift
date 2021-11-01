import CryptoKit
import Foundation

// Block
final class Block {
  private(set) var index: UInt
  private(set) var previousHash: String
  var hash: String!
  private(set) var nonce: UInt = 0
  private(set) var transactions: [Transaction]
  
  var key: String {
    let transactionsData = try! JSONEncoder().encode(transactions)
    let transactionJsonString = String(data: transactionsData, encoding: .utf8)!
    return String(index) + previousHash + String(nonce) + transactionJsonString
  }
  
  init(index: UInt, previousHash: String) {
    self.index = index
    self.previousHash = previousHash
    self.transactions = []
  }
  
  func add(transaction: Transaction) {
    transactions.append(transaction)
  }
  
  func incrementNonce() {
    nonce += 1
  }
}

// Blockchain
final class Blockchain {
  private(set) var blocks: [Block] = []
  
  var latestBlock: Block {
    return blocks[blocks.count - 1]
  }
  
  init(genesisBlock: Block) {
    blocks.append(genesisBlock)
  }
  
  func add(block: Block) {
    blocks.append(block)
  }
}

// Transaction
final class Transaction: Encodable {
  let from: String
  let to: String
  let amount: Double
  
  init(from: String, to: String, amount: Double) {
    self.from = from
    self.to = to
    self.amount = amount
  }
}

// Mining
final class MiningService {
  
  private var blockchainDifficulty: String
  
  init(difficulty: String) {
    blockchainDifficulty = difficulty
  }
  
  // mine block method
  func mineBlock(previousBlock: Block, transactions: [Transaction]) -> Block {
    let nextIndex = previousBlock.index + 1
    print("⛏ Starting to mine the block at height \(nextIndex)...")
    let block = Block(index: nextIndex, previousHash: previousBlock.hash)
    transactions.forEach { block.add(transaction: $0) }
    
    let hash = generateHash(for: block)
    block.hash = hash
    
    return block
  }
  
  // generate hash method
  func generateHash(for block: Block) -> String {
    print("🔑 Searching the hash for block at height \(block.index)...")
    var hash = block.key.toSHA1()
    
    while !hash.hasPrefix(blockchainDifficulty) {
      block.incrementNonce()
      hash = block.key.toSHA1()
      print(hash)
    }
    
    print("🙌 Hash found! - \(hash)")
    return hash
  }
}

// Sha-1
extension String {
  func toSHA1() -> String {
    let data = self.data(using: .utf8)!
    let digest = Insecure.SHA1.hash(data: data)
    return digest.hexStr
  }
}

extension Digest {
  var bytes: [UInt8] { Array(makeIterator()) }
  var data: Data { Data(bytes) }
  
  var hexStr: String {
    bytes.map { String(format: "%02X", $0) }.joined()
  }
}

/// Exercise 1

// Creates the Mining Service
let miningService = MiningService(difficulty: "00") // starting with just 2 zeroes
// Generates Genesis Block
let genesisBlock = Block(index: 0, previousHash: "0000000000000000000000000000000000000000") // 40 zeroes
// Tries to find the hash for the genesis block
genesisBlock.hash = miningService.generateHash(for: genesisBlock)
// Once it finds the hash, create the Blockchain
let blockchain = Blockchain(genesisBlock: genesisBlock)
print("Blockchain is ready! 🎉")

/// Exercise 2

// Set a transaction
let transaction = Transaction(from: "Felipe", to: "Tim Cook", amount: 100)
// Creates a new block
let newBlock = miningService.mineBlock(previousBlock: genesisBlock, transactions: [transaction])
// Add to the chain

blockchain.add(block: newBlock)
