//
//  VerificationCodeView.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 14/10/25.
//

import SwiftUI

struct VerificationCodeView: View {
    @StateObject private var viewModel = VerificationCodeViewModel()
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 30) {
            Text("Verificación OTP")
                .font(.largeTitle.bold())
                .padding(.top, 50)

            Text("Selecciona cómo quieres recibir el código y luego ingrésalo para verificar tu identidad.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)

            // Picker para seleccionar el método
            VStack(alignment: .leading, spacing: 8) {
                Text("Método de envío")
                    .font(.headline)
                Picker("Selecciona un método", selection: $viewModel.selectedMethod) {
                    ForEach(OTPSendMethod.allCases) { method in
                        Text(method.rawValue).tag(method)
                    }
                }
                .pickerStyle(.segmented)
            }

            // Campo OTP visual (cajas)
            HStack(spacing: 10) {
                ForEach(0..<6) { index in
                    OTPDigitBox(
                        text: viewModel.otpCode.count > index
                            ? String(viewModel.otpCode[viewModel.otpCode.index(viewModel.otpCode.startIndex, offsetBy: index)])
                            : ""
                    )
                }
            }
            .padding(.vertical, 10)
            .contentShape(Rectangle())
            .onTapGesture {
                isFocused = true
            }
            
            TextField("", text: $viewModel.otpCode)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .focused($isFocused)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isFocused = true
                    }
                }
                .onChange(of: viewModel.otpCode) { newValue in
                    if newValue.count > 6 {
                        viewModel.otpCode = String(newValue.prefix(6))
                    }
                    if newValue.count == 6 {
                        Task { await viewModel.verifyOTP() }
                        isFocused = false
                    }
                }
                .frame(width: 0, height: 0)
            
            Button {
                Task { await viewModel.sendOTP() }
            } label: {
                HStack {
                    if viewModel.isLoading {
                        ProgressView().tint(.white)
                    } else {
                        Text("Enviar OTP")
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
            
            if let message = viewModel.message {
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(viewModel.showError ? .red : .green)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .padding(.horizontal, 30)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .onTapGesture {
            hideKeyboard()
        }
    }
}


// MARK: - Caja de dígitos individuales
struct OTPDigitBox: View {
    let text: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                .frame(width: 45, height: 55)
            Text(text)
                .font(.title2)
                .fontWeight(.semibold)
        }
    }
}


// MARK: - Ocultar teclado
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

#Preview {
    VerificationCodeView()
}
