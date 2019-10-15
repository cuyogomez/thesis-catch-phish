//
//  NotificationManager.swift
//  CatchPhish
//
//  Created by Claudio Gomez on 10/11/19.
//  Copyright © 2019 Claudio Gomez. All rights reserved.
//

import Foundation
import UserNotifications

enum NotificationConstants: String {
    case notificationCategory = "network_request_category"
}

class NotificationManager {
    static let shared = NotificationManager()
    
    func registerForNotifications(completion:@escaping ((Error?)->())) {
           DispatchQueue.main.async {
               UNUserNotificationCenter.current().setNotificationCategories([Notifications.authorizeCategory])
               UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (success, error) in
                   if let err = error {
                       print("got error requesting push notifications: \(err)")
                       return
                   }
                   
                   print("registered for push: \(success)")
                   completion(error)
               })
           }
       }
}

class Notifications {
    static var authorizeCategory:UNNotificationCategory = {
        return UNNotificationCategory(identifier: NotificationConstants.notificationCategory.rawValue,
                                      actions: [],
                                      intentIdentifiers: [],
                                      hiddenPreviewsBodyPlaceholder: "Incoming network request",
                                      options: .customDismissAction)
    }()
    
    
//    static var edit:UNNotificationAction = {
//        return UNNotificationAction(identifier: Constants.NotificationAction.edit.id,
//                                    title: "Edit rules",
//                                    options: .foreground)
//    }()
//
//    static var denyAllApp:UNNotificationAction = {
//        return UNNotificationAction(identifier: Constants.NotificationAction.denyApp.id,
//                                    title: "Drop all for this app",
//                                    options: .destructive)
//    }()


}
