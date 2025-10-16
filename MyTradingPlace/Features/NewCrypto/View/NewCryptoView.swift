//
//  NewCryptoView.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 15/10/25.
//

import SwiftUI

struct NewCryptoView: View {
    
    @StateObject private var viewModel = NewCryptoViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Nombre de la Criptomoneda")
                        .font(.headline)
                    
                    TextField("Ej: Bitcoin", text: $viewModel.name)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Símbolo")
                        .font(.headline)
                    
                    TextField("Ej: BTC", text: $viewModel.symbol)
                        .autocapitalization(.allCharacters)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.saveCrypto {
                        dismiss()
                    }
                }) {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("Guardar Criptomoneda")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isFormValid ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(!viewModel.isFormValid || viewModel.isLoading)
                .animation(.default, value: viewModel.isFormValid)
                
            }
            .padding(30)
            .navigationTitle("Agregar Crypto")
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
    }
}

struct AddCryptoView_Previews: PreviewProvider {
    static var previews: some View {
        NewCryptoView()
    }
}
