//
//  LoginViewModel.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 14/10/25.
//

import SwiftUI
import Combine

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
    
    private let appViewModel: AppViewModel
    private lazy var loginClient: LoginClientProvider = LoginClient()
    private var cancellables = Set<AnyCancellable>()
    
    
    init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
    }
    
    
    // MARK: - Actions

    func login() {
        guard validateFields() else { return }
        
        isLoading = true
        showError = false
        
        let publisher = if selectedMethod == .document {
            loginClient.loginV1(parameters: DocumentCredentials(document: emailOrDocument, password: password))
        } else {
            loginClient.loginV2(parameters: EmailCredentials(email: emailOrDocument, password: password))
        }
        
        publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                
                isLoading = false
                
                showErrorMessage("Se ha presentado un error inesperado, por favor uintenta de nuevo.")
            }, receiveValue: { [weak self] response in
                guard let self else { return }
                
                USerService.userSession = response
                isLoading = false
                
                appViewModel.goToHome()
            })
            .store(in: &cancellables)
    }

    func loginWithOTP() {
        print("Login con Google")
    }
    
    func didValidateOtp() {
        appViewModel.goToHome()
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
