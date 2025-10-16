//
//  Crypto.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 14/10/25.
//

import SwiftUI

struct Crypto: Identifiable, Hashable, Codable {
    
    let id: Int?
    let name: String
    let symbol: String
    
    init(id: Int? = nil,
         name: String,
         symbol: String) {
        self.id = id
        self.name = name
        self.symbol = symbol
    }
}
