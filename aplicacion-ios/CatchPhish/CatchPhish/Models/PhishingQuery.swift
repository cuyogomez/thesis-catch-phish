//
//  PhishingQuery.swift
//  CatchPhish
//
//  Created by Claudio Gomez on 10/9/19.
//  Copyright © 2019 Claudio Gomez. All rights reserved.
//

import Foundation

enum Endpoints: String {
    case server = "http://tesis-env.qhprpekfhi.us-east-2.elasticbeanstalk.com/predict"
}

struct PhishingQuery: Codable {
    let url: String
    
    var bodyRequest: Data? {
        return "{\"url\":\"\(url)\"}".data(using: .utf8)
    }
}

extension Encodable {
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }
}
