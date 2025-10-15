//
//  MyTradingPlaceApp.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 14/10/25.
//

import SwiftUI

@main
struct MyTradingPlaceApp: App {
    
    @StateObject private var appViewModel = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appViewModel)
        }
    }
}
