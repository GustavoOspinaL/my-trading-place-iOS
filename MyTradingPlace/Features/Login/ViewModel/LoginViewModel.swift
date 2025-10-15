//
//  LoginViewModel.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 14/10/25.
//

import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    
    
    // MARK: - Public Properties
    
    @Published var selectedMethod = LoginMethod.email
    @Published var emailOrDocument = ""
    @Published var documentLength = 0
    @Published var password = ""
    @Published var isSecure = true
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    
    
    // MARK: - Actions

    func login() async {
        guard validateFields() else { return }

        isLoading = true
        showError = false
        
        try? await Task.sleep(for: .seconds(1.5))

        isLoading = false

        switch selectedMethod {
        case .email:
            print("Login con correo: \(emailOrDocument)")
        case .document:
            print("Login con documento: \(emailOrDocument)")
        }
    }

    func loginWithOTP() {
        print("Login con Google")
    }
    
    
    // MARK: - Validaciones

    private func validateFields() -> Bool {
        guard !emailOrDocument.isEmpty, !password.isEmpty else {
            showErrorMessage("Por favor completa todos los campos.")
            return false
        }

        switch selectedMethod {
        case .email:
            guard emailOrDocument.contains("@") else {
                showErrorMessage("El correo ingresado no es válido.")
                return false
            }
        case .document:
            guard Int(emailOrDocument) != nil else {
                showErrorMessage("El número de documento debe ser numérico.")
                return false
            }
        }

        return true
    }
}


// MARK: - Private methods

private extension LoginViewModel {
    
    func showErrorMessage(_ message: String) {
        showError = true
        errorMessage = message
    }
}
