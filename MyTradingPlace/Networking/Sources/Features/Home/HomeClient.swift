//
//  HomeClient.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 15/10/25.
//

import Combine

final class HomeClient: RestClient, HomeClientProvider {
    
    func addCrypto(parameters: Crypto, sessionId: String?) -> AnyPublisher<Crypto, APIError> {
        return request(resource: HomeResource.addCrypto(sessionId: sessionId), parameters: parameters)
    }
    
    func cryptos(sessionId: String?) -> AnyPublisher<[Crypto], APIError> {
        return request(resource: HomeResource.cryptos(sessionId: sessionId))
    }
}
