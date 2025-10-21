//
//  AppViewModel.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 14/10/25.
//

import SwiftUI

@MainActor
final class AppViewModel: ObservableObject {
    @Published var currentRoute: AppRouteType = .login

    func goToHome() {
        currentRoute = .home
    }

    func logout() {
        USerService.userSession = nil
        currentRoute = .login
    }
}
