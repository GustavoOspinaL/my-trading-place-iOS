//
//  HomeView.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 14/10/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.users.isEmpty {
                    ContentUnavailableView(
                        "Sin usuarios",
                        systemImage: "person.crop.circle.badge.xmark",
                        description: Text("Aún no hay usuarios registrados.")
                    )
                    .padding(.top, 100)
                } else {
                    List {
                        ForEach(viewModel.users) { user in
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.blue.opacity(0.8))

                                VStack(alignment: .leading) {
                                    Text(user.username)
                                        .font(.headline)
                                    Text(user.email)
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
            .navigationTitle("Usuarios")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        viewModel.logout()
                    }) {
                        Label("Cerrar sesión", systemImage: "arrow.backward.circle")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        viewModel.addUser()
                    }) {
                        Label("Agregar", systemImage: "plus.circle.fill")
                    }
                    .tint(.blue)
                }
            }
        }
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel(appViewModel: AppViewModel()))
}
