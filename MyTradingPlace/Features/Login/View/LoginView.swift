//
//  LoginView.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 14/10/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                Text("Bienvenido")
                    .font(.largeTitle.bold())
                    .padding(.top, 50)
                
                Picker("Método de inicio de sesión", selection: $viewModel.selectedMethod) {
                    ForEach(LoginMethod.allCases) { method in
                        Text(method.id).tag(method)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 10)
                
                VStack(alignment: .leading, spacing: 16) {
                    TextField(viewModel.selectedMethod.id, text: $viewModel.emailOrDocument)
                        .keyboardType(viewModel.selectedMethod == .email ? .emailAddress : .numberPad)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    
                    HStack {
                        if viewModel.isSecure {
                            SecureField("Contraseña", text: $viewModel.password)
                        } else {
                            TextField("Contraseña", text: $viewModel.password)
                        }
                        
                        Button(action: {
                            viewModel.isSecure.toggle()
                        }) {
                            Image(systemName: viewModel.isSecure ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                }
                
                Button {
                    viewModel.login()
                } label: {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("Iniciar sesión")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(viewModel.isLoading)
                
                if viewModel.showError {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.subheadline)
                }
                
                VStack(spacing: 15) {
                    HStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.3))
                        Text("o continúa con")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray.opacity(0.3))
                    }
                    
                    NavigationLink(destination: VerificationCodeView()) {
                        HStack {
                            Image(systemName: "globe")
                            Text("Código de verificación")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .animation(.easeInOut, value: viewModel.selectedMethod)
        }
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(appViewModel: AppViewModel()))
}

