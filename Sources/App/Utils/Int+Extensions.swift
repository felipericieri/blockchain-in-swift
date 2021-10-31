//
//  File.swift
//  
//
//  Created by Felipe Ricieri on 28/10/2021.
//

import Foundation

extension Int {
  
  // Generates String with X zeros
  var zeros: String {
    return ([String](repeating: "0", count: self)).reduce("", { "\($0)\($1)"} )
  }
}
