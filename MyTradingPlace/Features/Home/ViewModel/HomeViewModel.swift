//
//  HomeViewModel.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 14/10/25.
//

import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {

    @Published var cryptos: [Crypto] = []

    private lazy var homeClient: HomeClientProvider = HomeClient()
    private var cancellables = Set<AnyCancellable>()
    private let appViewModel: AppViewModel
    
    init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
    }

    func loadCryptos() {
        homeClient.cryptos(sessionId: USerService.userSession?.tokenJWT)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("TL: ", error.localizedDescription)
                }
            }, receiveValue: { [weak self] response in
                guard let self else { return }
                
                cryptos = response
            })
            .store(in: &cancellables)
    }

    func addCrypto() {
    }
    
    func logout() {
        USerService.userSession = nil
        
        appViewModel.logout()
    }
}
