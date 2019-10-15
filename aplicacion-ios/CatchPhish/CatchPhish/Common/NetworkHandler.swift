//
//  NetworkHandler.swift
//  CatchPhish
//
//  Created by Claudio Gomez on 10/13/19.
//  Copyright © 2019 Claudio Gomez. All rights reserved.
//

import Foundation

enum HTTPError: LocalizedError {
    case statusCode
    case post
}

class NetworkHandler {
    
    static func createRequest(url: String) -> URLRequest? {
        guard let serverUrl = URL(string: Endpoints.server.rawValue) else {
            return nil
        }
        
        var request = URLRequest(url: serverUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        guard let _ = URL(string: url), let body = PhishingQuery(url: url).bodyRequest else {
            NSLog("If body can be created, we allow the request")
            return nil
        }
        
        request.httpBody = body
        
        return request
    }
}
