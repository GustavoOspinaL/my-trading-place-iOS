//
//  ContentView.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 14/10/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appViewModel = AppViewModel()
    
    var body: some View {
        switch appViewModel.currentRoute {
        case .login:
            LoginView()
                .environmentObject(appViewModel)
        case .home:
            HomeView()
                .environmentObject(appViewModel)
        }
    }
}

#Preview {
    ContentView()
}
