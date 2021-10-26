//
//  String+Extentions.swift
//
//  Created by Felipe Ricieri on 26/10/21.
//

import Foundation

extension String {
    
  func sha1Hash() -> String {
    
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
