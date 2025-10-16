//
//  NewCryptoViewModel.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 15/10/25.
//

import Combine
import SwiftUI

@MainActor
final class NewCryptoViewModel: ObservableObject {
    
    @Published var name = ""
    @Published var symbol = ""
    @Published var isLoading = false
    
    private lazy var homeClient: HomeClientProvider = HomeClient()
    private var cancellables = Set<AnyCancellable>()
    
    var isFormValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !symbol.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func saveCrypto(onSuccess: @escaping () -> Void) {
        guard isFormValid else { return }
        
        isLoading = true
        
        homeClient.addCrypto(parameters: Crypto(name: name, symbol: symbol), sessionId: USerService.userSession?.tokenJWT)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                
                isLoading = false

                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("TL: ", error.localizedDescription)
                }
            }, receiveValue: { [weak self] response in
                guard self != nil else { return }
                
                print("TL: ", response)
                onSuccess()
            })
            .store(in: &cancellables)
    }
}
