//
//  VerificationCodeViewModel.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 14/10/25.
//

import SwiftUI
import Combine

@MainActor
final class VerificationCodeViewModel: ObservableObject {
    
    @Published var otpCode = ""
    @Published var emailOrPhone = ""
    @Published var selectedMethod: OTPMethodType = .sms
    @Published var isOTPSent: Bool = false
    @Published var isLoading = false
    @Published var showError = false
    @Published var message: String? = nil
    @Published var viewDescription = ""
    
    private lazy var loginClient: LoginClientProvider = LoginClient()
    private var cancellables = Set<AnyCancellable>()
    private var viewOutput: LoginViewOutput
    
    init(viewOutput: LoginViewOutput) {
        self.viewOutput = viewOutput
        
        makeViewDescription()
    }
    
    
    // MARK: - Funciones
    
    func sendOTP() async {
        guard validateFields() else { return }
        
        isLoading = true
        showError = false
        message = nil
        
        loginClient.sendNotification(parameters: Notification(channel: selectedMethod.rawValue, destination: emailOrPhone))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                
                isLoading = false
                
                switch completion {
                case .finished:
                    isOTPSent = true
                    makeViewDescription()
                case .failure(let error):
                    showErrorMessage(error.localizedDescription)
                }
            }, receiveValue: { [weak self] response in
                guard let self else { return }
                
                showError = !response.success
                message = response.message
            })
            .store(in: &cancellables)
    }
    
    func verifyOTP() async {
        guard otpCode.count == 6 else { return }
        
        isLoading = true
        showError = false
        
        loginClient.loginV3(parameters: OtpCode(otpCode: otpCode))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                
                isLoading = false
                
                switch completion {
                case .finished:
                    viewOutput.didValidateOtp()
                case .failure(let error):
                    showErrorMessage(error.localizedDescription)
                }
            }, receiveValue: { [weak self] response in
                guard self != nil else { return }
                
                USerService.userSession = response
            })
            .store(in: &cancellables)
    }
    
    func changeVerificationMethod() {
        isOTPSent = false
        otpCode = ""
        message = nil
    }
}

private extension VerificationCodeViewModel {
    
    func validateFields() -> Bool {
        guard !emailOrPhone.isEmpty else {
            showErrorMessage("Por favor completa todos los campos.")
            
            return false
        }
        
        if selectedMethod == .email {
            guard emailOrPhone.contains("@") else {
                showErrorMessage("El correo ingresado no es válido.")
                
                return false
            }
        }

        return true
    }
    
    func showErrorMessage(_ message: String) {
        self.message = message
        showError = true
    }
    
    func makeViewDescription() {
        viewDescription = isOTPSent ? "Ingrésa el código para verificar tu identidad." : "Selecciona cómo quieres recibir el código y luego ingrésalo para verificar tu identidad."
    }
}
