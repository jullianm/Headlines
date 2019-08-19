//
//  PreferencesModel.swift
//  Headlight
//
//  Created by Jullianm on 16/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import Foundation

enum HeadlinesType: String, CaseIterable {
    case top
    case all
}

enum Country: String, CaseIterable {
    case france
    case germany
    case england
    case usa
    case china
    case australia
    case sweden
    case nederlands
    case scotland
    case ireland
}

struct PreferencesCountry {
    var country: Country
    var isSelected: Bool
    
    static var all: [PreferencesCountry] {
        return Country.allCases.map {
            PreferencesCountry(country: $0, isSelected: false)
        }
    }
}

struct PreferencesHeadlines: Identifiable {
    var id = UUID()
    var type: HeadlinesType
    var isSelected: Bool
    
    static var all: [PreferencesHeadlines] {
        return HeadlinesType.allCases.map {
            PreferencesHeadlines(type: $0, isSelected: $0 == .top)
        }
    }
}

struct PreferencesCategory: Identifiable {
    var id = UUID()
    var name: HeadlinesCategory
    var isSelected: Bool
    var isFavorite: Bool
    
    static var all: [PreferencesCategory] {
        return HeadlinesCategory.allCases.map {
            PreferencesCategory(
                name: $0,
                isSelected: true,
                isFavorite: $0 == .sports
            )
        }
    }
}

