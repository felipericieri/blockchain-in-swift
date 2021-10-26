//
//  File.swift
//  
//
//  Created by Felipe Ricieri on 26/10/21.
//

import Foundation

protocol SmartContract {
  func apply(transaction: Transaction)
}
