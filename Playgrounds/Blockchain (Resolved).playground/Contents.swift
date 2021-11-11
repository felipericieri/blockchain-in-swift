import CryptoKit
import Foundation

// Transaction
struct Transaction: Encodable {
  let sender: String
  let receiver: String
  let amount: Double
  
  init(sender: String, receiver: String, amount: Double) {
    self.sender = sender
    self.receiver = receiver
    self.amount = amount
  }
}

// Block
final class Block {
  private(set) var height: UInt
  private(set) var previousHash: String
  var hash: String!
  private(set) var nonce: UInt = 0
  private(set) var transactions: [Transaction]
  
  var key: String {
    let transactionsData = try! JSONEncoder().encode(transactions)
    let transactionJsonString = String(data: transactionsData, encoding: .utf8)!
    return String(height) + previousHash + String(nonce) + transactionJsonString
  }
  
  init(height: UInt, previousHash: String) {
    self.height = height
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
  enum Error: Swift.Error {
    case invalidHash
  }
  
  private(set) var blocks: [Block] = []
  
  private let difficulty: String
  
  var latestBlock: Block {
    return blocks[blocks.count - 1]
  }
  
  init(difficulty: String, genesisBlock: Block) {
    self.difficulty = difficulty
    blocks.append(genesisBlock)
  }
  
  func add(block: Block) throws {
    if !block.hash.hasPrefix(difficulty) {
      throw Error.invalidHash
    }
    
    blocks.append(block)
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
    let nextHeight = previousBlock.height + 1
    print("⛏ Starting to mine the block at height \(nextHeight)...")
    let block = Block(height: nextHeight, previousHash: previousBlock.hash)
    transactions.forEach { block.add(transaction: $0) }
    
    let hash = generateHash(for: block)
    block.hash = hash
    
    return block
  }
  
  // generate hash method
  func generateHash(for block: Block) -> String {
    print("🔑 Searching the hash for block at height \(block.height)...")
    var hash = block.key.toSHA1()
    
    // Try your own solution here!
    
    // Previous algorithm
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
  /// Generates SHA1 Hashes
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

/// Exercise 3 (Challenge)

// The blockchain difficulty
let blockchainDifficulty = "00"
// Creates the Mining Service
let miningService = MiningService(difficulty: blockchainDifficulty)
// Generates Genesis Block
let genesisBlock = Block(height: 0, previousHash: "0000000000000000000000000000000000000000")
genesisBlock.hash = miningService.generateHash(for: genesisBlock)
// Once it finds the hash, create the Blockchain
let blockchain = Blockchain(difficulty: blockchainDifficulty, genesisBlock: genesisBlock)
print("Blockchain is ready! 🎉")

let now = Date()

// Creates a new Transaction
let transaction = Transaction(sender: "Felipe", receiver: "Tim Cook", amount: 100)

do {
  // Mines a new block for the transaction
  let newBlock = miningService.mineBlock(previousBlock: genesisBlock, transactions: [transaction])
  try blockchain.add(block: newBlock)

  let later = Date()
  let timeSpentMining = now.distance(to: later)

  print("👾 Block took \(timeSpentMining) seconds to mine the block at height \(blockchain.latestBlock.height)")
} catch {
  print("🚨 Oh oh! The hash isn't valid. It needs to conform with the blockchain difficulty")
}
