//
//  SettingsConfiguration.swift
//  CatchPhish
//
//  Created by Claudio Gomez on 9/7/19.
//  Copyright © 2019 Claudio Gomez. All rights reserved.
//

import Combine

final class SettingsConfiguration: ObservableObject {
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @UserDefault(key: "FirewallStatus", defaultValue: false)
    var isFirewallStarted: Bool {
        didSet {
            objectWillChange.send()
        }
    }
}



