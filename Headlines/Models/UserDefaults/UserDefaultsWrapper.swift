//
//  UserDefaultsManager.swift
//  Headlines
//
//  Created by Jullianm on 01/09/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefaultWrapper<T> {
    let key: String
    let value: T

    init(_ key: String, value: T) {
        self.key = key
        self.value = value
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? value
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
