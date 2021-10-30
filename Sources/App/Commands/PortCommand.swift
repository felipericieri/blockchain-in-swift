//
//  PortCommand.swift
//
//  Created by Felipe Ricieri on 28/10/2021.
//

import Vapor

struct HelloCommand: Command {
  struct Signature: CommandSignature { }

  var help: String {
    "Says hello"
  }

  func run(using context: CommandContext, signature: Signature) throws {
    context.console.print("Hello, world!")
  }
}
