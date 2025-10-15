//
//  VerificationCodeViewModel.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 14/10/25.
//

import SwiftUI

enum OTPSendMethod: String, CaseIterable, Identifiable {
    case sms = "SMS"
    case email = "Email"
    case whatsapp = "WhatsApp"

    var id: String { self.rawValue }
}

@MainActor
final class VerificationCodeViewModel: ObservableObject {
    @Published var otpCode: String = ""
    @Published var selectedMethod: OTPSendMethod = .sms
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var message: String? = nil
    
    // MARK: - Funciones
    
    func sendOTP() async {
        isLoading = true
        showError = false
        message = nil
        
        try? await Task.sleep(for: .seconds(1.5))
        isLoading = false
        
        message = "Se envió el código OTP por \(selectedMethod.rawValue)."
        print("📨 Enviando OTP por \(selectedMethod.rawValue)...")
    }
    
    func verifyOTP() async {
        guard otpCode.count == 6 else { return }
        
        isLoading = true
        showError = false
        message = nil
        
        try? await Task.sleep(for: .seconds(1.5))
        isLoading = false
        
        // Aquí podrías conectar con tu backend o API real
        print("✅ OTP verificado: \(otpCode)")
        message = "OTP verificado correctamente ✅"
    }
}
