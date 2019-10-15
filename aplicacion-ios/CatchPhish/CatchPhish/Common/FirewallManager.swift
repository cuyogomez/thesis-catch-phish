//
//  FirewallManager.swift
//  CatchPhish
//
//  Created by Claudio Gomez on 10/8/19.
//  Copyright © 2019 Claudio Gomez. All rights reserved.
//

import Foundation
import NetworkExtension

enum FirewallOptions: String {
    case start = "start"
    case stop = "stop"
    case activate = "activate"
    case deactivate = "deactivate"
}

class FirewallManager {
    static let activityType = "firewall-configuration"
    static let shared = FirewallManager()
    
    
    
    func loadPreferences() {
        NEFilterManager.shared().loadFromPreferences { error in
            if let loadError = error {
                NSLog("Error loading preferences: \(loadError)")
                return
            }
        }
    }
    
    func enableFirewall() {
        if NEFilterManager.shared().providerConfiguration == nil {
            let newConfiguration = NEFilterProviderConfiguration()
            newConfiguration.username = "CatchPhish"
            newConfiguration.organization = "CatchPhish App"
            newConfiguration.filterBrowsers = true
            newConfiguration.filterSockets = true
            NEFilterManager.shared().providerConfiguration = newConfiguration
        }

        NEFilterManager.shared().isEnabled = true
        NEFilterManager.shared().saveToPreferences { error in
            if let err = error {
                NSLog("Error saving preferences when enabling: \(err)")
            }
        }
    }
    
    func disableFirewall() {
        NEFilterManager.shared().isEnabled = false
        NEFilterManager.shared().saveToPreferences { error in
            if let err = error {
               NSLog("Error saving preferences when disabling: \(err)")
            }
        }
    }
    
    func executeAction(_ option: FirewallOptions) {
        let userDefaults = UserDefaults.group
        switch option {
        case .activate, .start:
            if let userDefaults = userDefaults, !userDefaults.bool(forKey: "FirewallStatus") {
                userDefaults.set(true, forKey: "FirewallStatus")
                enableFirewall()
            }
        case .deactivate, .stop:
            if let userDefaults = userDefaults, userDefaults.bool(forKey: "FirewallStatus") {
                userDefaults.set(false, forKey: "FirewallStatus")
                disableFirewall()
            }
        }
    }
}
