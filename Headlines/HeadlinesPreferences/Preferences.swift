//
//  HeadlinesPreferences.swift
//  Headlight
//
//  Created by Jullianm on 16/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

class Preferences {
    var type = PreferencesHeadlines.all
    var country = Country.france
    var categories = PreferencesCategory.all
    
    
    // MARK: User preferences
    var selectedType: HeadlinesType {
        return (type.filter { $0.isSelected }.first?.type) ?? .top
    }
    
    var selectedCountry: Country {
        return country
    }
    
    var selectedCategories: [PreferencesCategory] {
        return categories.filter { $0.isSelected }
    }
}

