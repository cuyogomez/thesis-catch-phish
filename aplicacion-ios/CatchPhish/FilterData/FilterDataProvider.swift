//
//  FilterDataProvider.swift
//  FilterData
//
//  Created by Claudio Gomez on 10/9/19.
//  Copyright © 2019 Claudio Gomez. All rights reserved.
//

import NetworkExtension

class FilterDataProvider: NEFilterDataProvider {
    
    override func startFilter(completionHandler: @escaping (Error?) -> Void) {
        // Add code to initialize the filter.
        completionHandler(nil)
    }
    
    override func stopFilter(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        // Add code to clean up filter resources.
        completionHandler()
    }
    
    override func handleNewFlow(_ flow: NEFilterFlow) -> NEFilterNewFlowVerdict {
//        self.cancellable = URLSession.shared.dataTaskPublisher(for: request)
//            .tryMap { output in
//                guard let response = output.response as? HTTPURLResponse,
//                        response.statusCode == 200 else {
//                        throw HTTPError.statusCode
//                }
//                return output.data }
//            .decode(type: Prediction.self, decoder: JSONDecoder())
//            .replaceError(with: Prediction(prediction: "-1"))
//            .eraseToAnyPublisher()
//            .sink(receiveValue: { prediction in
//                result = prediction
//
//                if let prediction = result, prediction.isPhishing {
//                    self.triggerPhishingAlert(for: url, in: flow.sourceAppIdentifier)
//                }
//            })
        
        return .needRules()
    }
}
