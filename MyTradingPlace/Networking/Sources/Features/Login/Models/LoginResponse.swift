//
//  LoginResponse.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 15/10/25.
//

struct LoginResponse: Codable {
    let tokenJWT: String
    let refreshToken: String
}
