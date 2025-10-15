//
//  LoginMethodType.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 14/10/25.
//

enum LoginMethod: String, CaseIterable, Identifiable {
    case email = "Correo electrónico"
    case document = "Número de documento"
    
    var id: String { self.rawValue }
}
