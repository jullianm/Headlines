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
    case gb
    case usa
    case china
    case australia
    case sweden
    case nederlands
    case japan 
    
    var convert: String {
        switch self {
        case .france:
            return "fr"
        case .germany:
            return "de"
        case .gb:
            return "gb"
        case .usa:
            return "us"
        case .china:
            return "cn"
        case .australia:
            return "au"
        case .sweden:
            return "se"
        case .nederlands:
            return "nl"
        case .japan:
            return "jp"
        }
    }
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
                isSelected: $0 == .business,
                isFavorite: $0 == .business
            )
        }
    }
}

