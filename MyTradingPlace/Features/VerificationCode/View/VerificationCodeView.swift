//
//  VerificationCodeView.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 14/10/25.
//

import SwiftUI

struct VerificationCodeView: View {
    
    @StateObject var viewModel: VerificationCodeViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Verificación OTP")
                .font(.largeTitle.bold())
                .padding(.top, 50)

            Text(viewModel.viewDescription)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            if !viewModel.isOTPSent {
                sendOTPSection
            } else {
                verifyOTPSection
            }
            
            if let message = viewModel.message {
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(viewModel.showError ? .red : .green)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .transition(.opacity) // Añade una pequeña animación
            }

            Spacer()
        }
        .padding(.horizontal, 30)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .onTapGesture {
            hideKeyboard()
        }
        .animation(.default, value: viewModel.isOTPSent)
    }
    
    
    // MARK: - Vista para Enviar OTP
    
    private var sendOTPSection: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Método de envío")
                    .font(.headline)
                Picker("Selecciona un método", selection: $viewModel.selectedMethod) {
                    ForEach(OTPMethodType.allCases) { method in
                        Text(method.rawValue).tag(method)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            TextField(viewModel.selectedMethod.id, text: $viewModel.emailOrPhone)
                .keyboardType(viewModel.selectedMethod == .email ? .emailAddress : .numberPad)
                .autocapitalization(.none)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
            
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
            .disabled(viewModel.isLoading || viewModel.emailOrPhone.isEmpty)
            .opacity(viewModel.emailOrPhone.isEmpty ? 0.6 : 1.0)
        }
        .transition(.asymmetric(insertion: .move(edge: .leading).combined(with: .opacity), removal: .move(edge: .leading).combined(with: .opacity)))
    }
    
    
    // MARK: - Vista para Verificar OTP
    
    private var verifyOTPSection: some View {
        VStack(spacing: 20) {
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
            .background(
                TextField("", text: $viewModel.otpCode)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .focused($isFocused)
                    .onChange(of: viewModel.otpCode) { _, newValue in
                        if newValue.count > 6 {
                            viewModel.otpCode = String(newValue.prefix(6))
                        }
                        if newValue.count == 6 {
                            Task { await viewModel.verifyOTP() }
                            isFocused = false
                        }
                    }
                    .frame(width: 0, height: 0)
            )
            .contentShape(Rectangle())
            .onTapGesture {
                isFocused = true
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isFocused = true
                }
            }
            
            Button("Cambiar método o reenviar código") {
                viewModel.changeVerificationMethod()
            }
            .font(.footnote)
            .foregroundColor(.blue)
            .padding(.top)
        }
        .transition(.asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity), removal: .move(edge: .trailing).combined(with: .opacity)))
    }
}


// MARK: - Caja de dígitos individuales
struct OTPDigitBox: View {
    let text: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.secondarySystemBackground))
                .frame(width: 45, height: 55)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
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
    VerificationCodeView(viewModel: VerificationCodeViewModel(viewOutput: LoginView(viewModel: LoginViewModel(appViewModel: AppViewModel()))))
}
