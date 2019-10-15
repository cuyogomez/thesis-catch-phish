//
//  UserDefaultsExtension.swift
//  CatchPhish
//
//  Created by Claudio Gomez on 9/7/19.
//  Copyright © 2019 Claudio Gomez. All rights reserved.
//

import Foundation

public extension UserDefaults {
    private static let appGroupIdentifier = "com.cuyo.catchphish.group.defaults.identifier"
    static var group: UserDefaults? {
        return UserDefaults(suiteName: UserDefaults.appGroupIdentifier)
    }
}

@propertyWrapper class UserDefault<T> {
    var key: String
    var defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            return UserDefaults.group?.object(forKey: key) as? T ?? defaultValue
        } set {
            UserDefaults.group?.set(newValue, forKey: key)
            UserDefaults.group?.synchronize()
        }
    }
}
