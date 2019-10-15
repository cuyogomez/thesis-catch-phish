//
//  IntentHandler.swift
//  ConfigureFirewallIntent
//
//  Created by Claudio Gomez on 10/13/19.
//  Copyright © 2019 Claudio Gomez. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        
        guard intent is ConfigureFirewallIntent else {
            return self
        }
        
        return ConfigureFirewallHandler()
    }
    
}



class ConfigureFirewallHandler: NSObject, ConfigureFirewallIntentHandling {
    func handle(intent: ConfigureFirewallIntent, completion: @escaping (ConfigureFirewallIntentResponse) -> Void) {
        guard let action = intent.action, let value = FirewallOptions(rawValue: action) else {
            completion(ConfigureFirewallIntentResponse(code: .failure, userActivity: nil))
            return
        }
        
        let userActivity = NSUserActivity(activityType: "firewall-configuration")
        userActivity.userInfo = ["action": action]
        completion(ConfigureFirewallIntentResponse.init(code: .continueInApp, userActivity: userActivity))
        completion(ConfigureFirewallIntentResponse.success(action: value.rawValue))
    }
    
    func resolveAction(for intent: ConfigureFirewallIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        guard let action = intent.action, let _ = FirewallOptions(rawValue: action) else {
            return
        }
        
        completion(INStringResolutionResult.success(with: action))
    }
    
    
}
