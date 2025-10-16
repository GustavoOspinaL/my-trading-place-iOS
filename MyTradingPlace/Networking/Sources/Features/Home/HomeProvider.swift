//
//  HomeProvider.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 15/10/25.
//

import Combine

protocol HomeClientProvider {
    
    func addCrypto(parameters: Crypto, sessionId: String?) -> AnyPublisher<Crypto, APIError>
    func cryptos(sessionId: String?) -> AnyPublisher<[Crypto], APIError>
}
