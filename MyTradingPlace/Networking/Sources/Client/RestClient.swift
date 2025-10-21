//
//  RestClient.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 14/10/25.
//

import Foundation
import Combine
import SwiftUI

class RestClient {
    
    static let shared = RestClient()
    
    private let baseURL = URL(string: "http://127.0.0.1:3000")!
    private let jsonDecoder: JSONDecoder
    private let jsonEncoder: JSONEncoder
    
    init() {
        self.jsonDecoder = JSONDecoder()
        self.jsonEncoder = JSONEncoder()
    }
    
    func request<T: Decodable, P: Encodable>(resource: Resource,
                                             parameters: P? = nil,
                                             headers: [String: String]? = nil) -> AnyPublisher<T, APIError> {
        let url = baseURL.appendingPathComponent(resource.resource.route)
        
        var request = URLRequest(url: url)
        
        request.httpMethod = resource.resource.method.rawValue
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if let token = resource.resource.sessionId {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let parameters {
            do {
                request.httpBody = try jsonEncoder.encode(parameters)
            } catch {
                return Fail(error: APIError.encodingError(error)).eraseToAnyPublisher()
            }
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { APIError.underlying($0) }
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                if httpResponse.statusCode == 401 {
                    throw APIError.invalidSession
                }
                
                guard 200..<300 ~= httpResponse.statusCode else {
                    throw APIError.requestFailed(httpResponse.statusCode)
                }
                
                return data
            }
            .decode(type: T.self, decoder: jsonDecoder)
            .mapError { error -> APIError in
                if let apiError = error as? APIError {
                    return apiError
                }
                
                return APIError.decodingError(error)
            }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .eraseToAnyPublisher()
    }
    
    func request<T: Decodable>(resource: Resource, headers: [String: String]? = nil) -> AnyPublisher<T, APIError> {
        let dummyBody: Never? = nil
        
        return request(resource: resource, parameters: dummyBody)
    }
}
