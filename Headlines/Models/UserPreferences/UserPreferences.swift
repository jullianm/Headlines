//
//  UserPreferences.swift
//  Headlines
//
//  Created by Jullianm on 16/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

struct UserPreferences {    
    var categories: [PreferencesCategory]
    var countries: [PreferencesCountry]
    var recencies: [PreferencesRecency]
    
    init() {
        self.categories = UserDefaultsManager.preferencesCategories
        self.countries = UserDefaultsManager.preferencesCountry
        self.recencies = UserDefaultsManager.preferencesRecency
    }
}

