//
//  LoginResource.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 15/10/25.
//

import Alamofire

enum LoginResource: Resource {
    
    case loginV1
    case loginV2
    case loginV3
    
    var resource: (method: HTTPMethod, route: String, sessionId: String?) {
        switch self {
        case .loginV1:
            return (.post, "/api/v1/auth/login", nil)
        case .loginV2:
            return (.post, "/api/v2/auth/login", nil)
        case .loginV3:
            return (.post, "/api/v3/auth/login", nil)
        }
    }
}
