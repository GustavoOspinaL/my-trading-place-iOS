//
//  Resource.swift
//  MyTradingPlace
//
//  Created by Tavo Lopez on 15/10/25.
//

import Alamofire

public protocol Resource {
    
    var resource: (method: HTTPMethod, route: String, sessionId: String?) { get }
}
