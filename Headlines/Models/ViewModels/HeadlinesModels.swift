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
enum HeadlinesCountry: Int, Codable, CaseIterable {
    case france
    case germany
    case GB
    case USA
    case china
    case australia
    case sweden
    case nederlands
    case japan
    
    var label: String {
        return "\(self)".capitalizingFirstLetter()
    }
    
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

struct PreferencesCountry: Codable {
    var country: HeadlinesCountry
    var isSelected: Bool
    
    init(country: HeadlinesCountry, isSelected: Bool) {
        self.country = country
        self.isSelected = isSelected
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        country = try container.decode(HeadlinesCountry.self, forKey: .country)
        isSelected = try container.decode(Bool.self, forKey: .isSelected)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(country, forKey: .country)
        try container.encode(isSelected, forKey: .isSelected)
    }
    
    enum CodingKeys: String, CodingKey {
        case country
        case isSelected
    }
    
    static var all: [PreferencesCountry] {
        return HeadlinesCountry.allCases.map {
            PreferencesCountry(country: $0, isSelected: $0 == .france)
        }
    }
}


// MARK: Categories
struct PreferencesCategory: Codable, Identifiable {
    var id = UUID()
    var name: HeadlinesSection
    var isSelected: Bool
    var isFavorite: Bool
    
    init(name: HeadlinesSection, isSelected: Bool, isFavorite: Bool) {
        self.name = name
        self.isSelected = isSelected
        self.isFavorite = isFavorite
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(HeadlinesSection.self, forKey: .name)
        isSelected = try container.decode(Bool.self, forKey: .isSelected)
        isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(isSelected, forKey: .isSelected)
        try container.encode(isFavorite, forKey: .isFavorite)
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case isSelected
        case isFavorite
    }
    
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
struct PreferencesRecency: Codable {
    var date: HeadlinesRecency
    var isSelected: Bool
    
    init(date: HeadlinesRecency, isSelected: Bool) {
        self.date = date
        self.isSelected = isSelected
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(HeadlinesRecency.self, forKey: .date)
        isSelected = try container.decode(Bool.self, forKey: .isSelected)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(isSelected, forKey: .isSelected)
    }
    
    enum CodingKeys: String, CodingKey {
        case date
        case isSelected
    }
    
    static var all: [PreferencesRecency] {
        return HeadlinesRecency.allCases.map {
            PreferencesRecency(date: $0, isSelected: $0 == .today)
        }
    }
}
enum HeadlinesRecency: Int, Codable, CaseIterable {
    case today
    case yesterday
    case threeDays
    case sevenDays
    
    var label: String {
        switch self {
        case .today:
            return "Today"
        case .yesterday:
            return "Yesterday"
        case .threeDays:
            return "3 days"
        case .sevenDays:
            return "7 days"
        }
    }
    
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
