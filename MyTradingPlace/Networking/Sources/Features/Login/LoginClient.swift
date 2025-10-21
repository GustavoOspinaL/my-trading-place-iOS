//
//  LoginClient.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 15/10/25.
//

import Combine

final class LoginClient: RestClient, LoginClientProvider {
    
    func loginV1(parameters: DocumentCredentials) -> AnyPublisher<LoginResponse, APIError> {
        return request(resource: LoginResource.loginV1, parameters: parameters)
    }
    
    func loginV2(parameters: EmailCredentials) -> AnyPublisher<LoginResponse, APIError> {
        return request(resource: LoginResource.loginV2, parameters: parameters)
    }
    
    func loginV3(parameters: OtpCode) -> AnyPublisher<LoginResponse, APIError> {
        return request(resource: LoginResource.loginV3, parameters: parameters)
    }
    
    func sendNotification(parameters: Notification) -> AnyPublisher<NotificationResponse, APIError> {
        return request(resource: LoginResource.sendNotification, parameters: parameters)
    }
}
