//
//  MiningService.swift
//
//  Created by Felipe Ricieri on 31/10/21.
//

import Foundation

/**
 Service used to Mine blocks
 */
final class MiningService {
  
  /// How many zeroes we'll need to regard so the hash can be accepted
  private var blockchainDifficulty: String
  
  // MARK: - Initialiser
  
  init(difficulty: String) {
    blockchainDifficulty = difficulty
  }
  
  // MARK: - Service features
  
  /// Mines a the next block in the blockchain
  func mineBlock(previousBlock: Block, transactions: [Transaction]) -> Block {
    let block = Block(index: previousBlock.index + 1, previousHash: previousBlock.hash)
    transactions.forEach { block.add($0) }
    
    let hash = generateHash(for: block)
    block.hash = hash
    
    return block
  }
  
  /// Generate Hash for Block according to the difficulty of this blockchain
  func generateHash(for block: Block) -> String {
    var hash = block.key.toSHA1()
    
    // Search for a hash prefix according to the Blockchain difficulty
    while !hash.hasPrefix(blockchainDifficulty) {
      block.incrementNonce()
      hash = block.key.toSHA1()
      print(hash)
    }
    
    return hash
  }
}

// MARK: - Helpers

extension String {
  
  /// Generates SHA1 Hashes
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
