//
//  HomeResource.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 15/10/25.
//

import Alamofire

enum HomeResource: Resource {
    
    case addCrypto(sessionId: String?)
    case cryptos(sessionId: String?)
    
    var resource: (method: HTTPMethod, route: String, sessionId: String?) {
        switch self {
        case .addCrypto(let sessionId):
            return (.post, "/api/v1/cryptos", sessionId)
        case .cryptos(let sessionId):
            return (.get, "/api/v1/cryptos", sessionId)
        }
    }
}
