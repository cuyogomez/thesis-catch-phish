//
//  FilterControlProvider.swift
//  FilterControl
//
//  Created by Claudio Gomez on 10/9/19.
//  Copyright © 2019 Claudio Gomez. All rights reserved.
//

import NetworkExtension
import Combine
import UserNotifications

class FilterControlProvider: NEFilterControlProvider {
    
    private var cancellable: AnyCancellable?
    private var task: URLSessionDataTask?
    
    override func startFilter(completionHandler: @escaping (Error?) -> Void) {
        // Add code to initialize the filter
        completionHandler(nil)
    }
    
    override func stopFilter(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        // Add code to clean up filter resources
        completionHandler()
    }
    
    override func handleNewFlow(_ flow: NEFilterFlow, completionHandler: @escaping (NEFilterControlVerdict) -> Void) {
        // Add code to determine if the flow should be dropped or not, downloading new rules if required
        
        NSLog("XXXXX> Started to analyze")
        
        guard let url = flow.url, url.absoluteString != Endpoints.server.rawValue else {
            NSLog("URL from the flow object doesn't exist, so we allow the request")
            completionHandler(.allow(withUpdateRules: false))
            return
        }
        
        checkURLStatus(url, sourceApp: flow.sourceAppIdentifier)
        
        completionHandler(.allow(withUpdateRules: false))
    }
    
    fileprivate func checkURLStatus(_ url: URL, sourceApp: String?) {
        
        guard let request = NetworkHandler.createRequest(url: url.absoluteString) else {
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("XXXXX> Error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                response.statusCode == 200 else {
                    NSLog("XXXXX> Error")
                    return
            }
            if let data = data,
                let prediction = try? JSONDecoder().decode(Prediction.self, from: data) {
                if prediction.isPhishing {
                    self.triggerPhishingAlert(for: url, in: sourceApp)
                }
            }
        }.resume()
    }
    
    fileprivate func triggerPhishingAlert(for url: URL, in app: String?) {
        UNUserNotificationCenter.current().getDeliveredNotifications { notes in
            
            let appId = app ?? ""
            let message = NSLocalizedString("alerts.phishingMessage", comment: "")
            let formatMessage = String(format: message, arguments: [url.absoluteString, appId])
            let content = UNMutableNotificationContent()
            content.categoryIdentifier = NotificationConstants.notificationCategory.rawValue
            content.userInfo = ["app": appId, "url": url.absoluteString]
            content.body =  formatMessage
            content.title = NSLocalizedString("alerts.phishing", comment: "")
            content.threadIdentifier = appId
            
            
            let id = UUID().uuidString
            
            let note = UNNotificationRequest(identifier: id,
                                             content: content,
                                             trigger: nil)
            
            
            UNUserNotificationCenter.current().add(note) { (err) in
                if err != nil {
                    print("XXXXX> err: \(err!)")
                }
            }
        }
    }
}
