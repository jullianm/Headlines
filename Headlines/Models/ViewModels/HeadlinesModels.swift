//
//  PreferencesModel.swift
//  Headlight
//
//  Created by Jullianm on 16/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import Foundation

// MARK: Headlines
struct Headlines: Identifiable {
    var id = UUID()
    var name: HeadlinesSection = .business
    var recency: HeadlinesRecency = .today
    var isFavorite: Bool = false
    var articles: [Article]
    
    init(name: HeadlinesSection, isFavorite: Bool, articles: [Article] = []) {
        self.name = name
        self.isFavorite = isFavorite
        self.articles = articles
    }
    
    static var all: [Headlines] {
        let categories = PreferencesCategory.all
            .filter { $0.isSelected }
            .map { Headlines(name: $0.name, isFavorite: $0.isFavorite) }

        return categories.sortedFavorite()
    }
}


// MARK: Countries
enum HeadlinesCountry: String, CaseIterable {
    case france
    case germany
    case GB
    case USA
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
        case .GB:
            return "gb"
        case .USA:
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
    var country: HeadlinesCountry
    var isSelected: Bool
    
    static var all: [PreferencesCountry] {
        return HeadlinesCountry.allCases.map {
            PreferencesCountry(country: $0, isSelected: $0 == .france)
        }
    }
}


// MARK: Categories
struct PreferencesCategory: Identifiable {
    var id = UUID()
    var name: HeadlinesSection
    var isSelected: Bool
    var isFavorite: Bool
    
    static var all: [PreferencesCategory] {
        return HeadlinesSection.allCases
            .filter { $0 != .filtered }
            .map {
                PreferencesCategory(
                    name: $0,
                    isSelected: true,
                    isFavorite: $0 == .technology
                )
        }
    }
}

// MARK: Recency
struct PreferencesRecency {
    var date: HeadlinesRecency
    var isSelected: Bool
    
    static var all: [PreferencesRecency] {
        return HeadlinesRecency.allCases.map {
            PreferencesRecency(date: $0, isSelected: $0 == .today)
        }
    }
}
enum HeadlinesRecency: String, CaseIterable {
    case today = "Today"
    case yesterday = "Yesterday"
    case threeDays = "3 days"
    case sevenDays = "7 days"
    
    var fromTo: (from: Date, to: Date) {
        switch self {
        case .today:
            return (from: Date.today, to: Date.today)
        case .yesterday:
            return (from: Date.yesterday, to: Date.today)
        case .threeDays:
            return (from: Date.threeDaysAgo, to: Date.today)
        case .sevenDays:
            return (from: Date.sevenDaysAgo, to: Date.today)
        }
    }
}
