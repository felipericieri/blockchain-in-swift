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
    
    // Try your own solution here!
    
    // Previous algorithm
//    while !hash.hasPrefix(blockchainDifficulty) {
//      block.incrementNonce()
//      hash = block.key.toSHA1()
//      print(hash)
//    }
    
    print("🙌 Hash found! - \(hash)")
    return hash
  }
}

// Sha-1
extension String {
  func toSHA1() -> String {
    
    let task = Process()
    task.launchPath = "/usr/bin/shasum"
    task.arguments = []
    
    let inputPipe = Pipe()
    
    inputPipe.fileHandleForWriting.write(self.data(using: String.Encoding.utf8)!)
    
    inputPipe.fileHandleForWriting.closeFile()
    
    let outputPipe = Pipe()
    task.standardOutput = outputPipe
    task.standardInput = inputPipe
    task.launch()
    
    let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
    let hash = String(data: data, encoding: String.Encoding.utf8)!
    return hash.replacingOccurrences(of: "  -\n", with: "")
  }
}

/// Exercise 3 (Challenge)

// The blockchain difficulty
let blockchainDifficulty = "00"
// Creates the Mining Service
let miningService = MiningService(difficulty: blockchainDifficulty)
// Generates Genesis Block
let genesisBlock = Block(index: 0, previousHash: "0000000000000000000000000000000000000000")
genesisBlock.hash = "008DEC3DABA9AFE958A873738A6664A26A56960F"
// Once it finds the hash, create the Blockchain
let blockchain = Blockchain(difficulty: blockchainDifficulty, genesisBlock: genesisBlock)
print("Blockchain is ready! 🎉")

let now = Date()

// Creates a new Transaction
let transaction = Transaction(from: "Felipe", to: "Tim Cook", amount: 100)

do {
  // Mines a new block for the transaction
  let newBlock = miningService.mineBlock(previousBlock: genesisBlock, transactions: [transaction])
  try blockchain.add(block: newBlock)

  let later = Date()
  let timeSpentMining = now.distance(to: later)

  print("👾 Block took \(timeSpentMining) seconds to mine the block at height \(blockchain.latestBlock.index)")
} catch {
  print("🚨 Oh oh! The hash isn't valid. It needs to conform with the blockchain difficulty")
}