//
//  HomeView.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 14/10/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.cryptos.isEmpty {
                    ContentUnavailableView(
                        "Sin cryptos",
                        systemImage: "person.crop.circle.badge.xmark",
                        description: Text("Aún no hay cryptos registradas.")
                    )
                    .padding(.top, 100)
                } else {
                    List {
                        ForEach(viewModel.cryptos) { crypto in
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.blue.opacity(0.8))

                                VStack(alignment: .leading) {
                                    Text(crypto.symbol)
                                        .font(.headline)
                                    Text(crypto.name)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Crptos")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        viewModel.logout()
                    }) {
                        Label("Cerrar sesión", systemImage: "arrow.backward.circle")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: NewCryptoView().environmentObject(appViewModel)) {
                        Label("Agregar", systemImage: "plus.circle.fill")
                    }.tint(.blue)
                }
            }.onAppear() {
                viewModel.loadCryptos()
            }
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(appViewModel: AppViewModel()))
}
