//
//  Prediction.swift
//  CatchPhish
//
//  Created by Claudio Gomez on 10/9/19.
//  Copyright © 2019 Claudio Gomez. All rights reserved.
//

import Foundation

enum PredictionValues: Int {
    case legitimate = -1
    case phishing = 1
}

struct Prediction: Codable {
    let prediction: String
    
    var isPhishing: Bool {
        guard let predictionValue = Int(prediction), let value = PredictionValues(rawValue: predictionValue) else {
            return false
        }
        
        NSLog("XXXXX> Prediction value: \(value)")
        
        return value == PredictionValues.phishing
    }
}
