//
//  OTPMethodType.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 15/10/25.
//

enum OTPMethodType: String, CaseIterable, Identifiable {
    case sms
    case email
    case whatsapp

    var id: String {
        switch self {
        case .sms: return "Número de teléfono"
        case .email: return "Correo electrónico"
        case .whatsapp: return "Número de whatsapp"
        }
    }
}
