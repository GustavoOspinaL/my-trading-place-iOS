//
//  APIError.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 14/10/25.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case requestFailed(Int)
    case decodingError(Error)
    case encodingError(Error)
    case underlying(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "La URL proporcionada no es válida."
        case .invalidResponse:
            return "La respuesta del servidor no fue válida."
        case .requestFailed(let statusCode):
            return "La solicitud falló con el código de estado: \(statusCode)."
        case .decodingError(let error):
            return "Error al decodificar la respuesta: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Error al codificar los datos de la solicitud: \(error.localizedDescription)"
        case .underlying(let error):
            return "Error subyacente: \(error.localizedDescription)"
        }
    }
}
