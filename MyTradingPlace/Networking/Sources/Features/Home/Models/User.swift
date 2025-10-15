//
//  User.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 14/10/25.
//

import SwiftUI

struct User: Identifiable, Hashable {
    let id = UUID()
    let document: String
    let username: String
    let email: String
    let phone: String
}
