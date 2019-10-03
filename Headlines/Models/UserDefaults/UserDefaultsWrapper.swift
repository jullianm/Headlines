//
//  UserDefaultWrapper.swift
//  Headlines
//
//  Created by Jullianm on 01/09/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefaultWrapper<T: Codable> {
    let key: String
    let value: T

    init(_ key: String, value: T) {
        self.key = key
        self.value = value
    }

    var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.value(forKey: key) as? Data else { return value }
            return (try? PropertyListDecoder().decode(T.self, from: data)) ?? value
        }
        set {
            let encoded = try? PropertyListEncoder().encode(newValue)
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
}
