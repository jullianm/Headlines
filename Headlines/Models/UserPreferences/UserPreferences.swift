//
//  UserPreferences.swift
//  Headlight
//
//  Created by Jullianm on 16/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

struct UserPreferences {    
    var categories: [PreferencesCategory]
    var countries: [PreferencesCountry]
    var recencies: [PreferencesRecency]
    
    init(
        categories: [PreferencesCategory] = PreferencesCategory.all,
        countries: [PreferencesCountry] = PreferencesCountry.all,
        recencies: [PreferencesRecency] = PreferencesRecency.all) {
        
        self.categories = categories
        self.countries = countries
        self.recencies = recencies
    }
    
}

