//
//  ContentView.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 14/10/25.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        switch appViewModel.currentRoute {
        case .login:
            LoginView(viewModel: LoginViewModel(appViewModel: appViewModel))
                .environmentObject(appViewModel)
        case .home:
            HomeView(viewModel: HomeViewModel(appViewModel: appViewModel))
                .environmentObject(appViewModel)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppViewModel())
}
