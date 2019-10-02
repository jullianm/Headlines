//
//  UserDefaultsManager.swift
//  Headlines
//
//  Created by Jullianm on 01/09/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import Foundation

struct UserDefaultsManager {    
    @UserDefaultWrapper("preferencesCategories", value: PreferencesCategory.all)
    static var preferencesCategories: [PreferencesCategory]
    
    @UserDefaultWrapper("preferencesCountry", value: PreferencesCountry.all)
    static var preferencesCountry: [PreferencesCountry]
    
    @UserDefaultWrapper("preferencesRecency", value: PreferencesRecency.all)
    static var preferencesRecency: [PreferencesRecency]
}
