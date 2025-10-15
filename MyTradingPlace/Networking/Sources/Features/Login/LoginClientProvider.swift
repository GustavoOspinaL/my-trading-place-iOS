//
//  LoginClientProvider.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 15/10/25.
//

import Combine

protocol LoginClientProvider {
    
    func loginV1(parameters: DocumentCredentials) -> AnyPublisher<LoginResponse, APIError>
    func loginV2(parameters: EmailCredentials) -> AnyPublisher<LoginResponse, APIError>
    func loginV3(parameters: OtpCode) -> AnyPublisher<LoginResponse, APIError>
    func sendNotification(parameters: Notification) -> AnyPublisher<NotificationResponse, APIError>
}
