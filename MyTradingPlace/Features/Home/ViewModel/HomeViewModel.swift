//
//  HomeViewModel.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 14/10/25.
//

import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {

    @Published var users: [User] = []
    
    init() {
        loadUsers()
    }

    func loadUsers() {
        users = [
            User(document: "123456789",
                 username: "Tavo López",
                 email: "tavo@example.com",
                 phone: "123456789")
        ]
    }

    func addUser() {
    }
}
