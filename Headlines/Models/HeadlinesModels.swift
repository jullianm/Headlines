//
//  HeadlinesModels.swift
//  Headlines
//
//  Created by Jullianm on 25/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import Foundation
import Combine

struct Headlines {
    let type: HeadlinesType
    let country: HeadlinesCountry
    var categories: [Category]
    
    init(type: HeadlinesType = .top, country: HeadlinesCountry = .france, categories: [Category] = []) {
        self.type = type
        self.country = country
        self.categories = categories
    }
    
    static var all: Headlines {
        let categories = HeadlinesCategory.allCases.map {
            Category(name: $0, isFavorite: $0 == .technology)
        }
                
        return Headlines(
            type: .top,
            country: .france,
            categories: categories.sortedFavorite()
        )
    }
}

struct Category: Identifiable {
    let id = UUID()
    var name: HeadlinesCategory = .business
    var isFavorite: Bool = false
    var articles: [Article]
    
    init(name: HeadlinesCategory, isFavorite: Bool, articles: [Article] = []) {
        self.name = name
        self.isFavorite = isFavorite
        self.articles = articles
    }
    
    static var all: [Category] {
        let categories = PreferencesCategory.all
            .filter { $0.isSelected }
            .map { Category(name: $0.name, isFavorite: $0.isFavorite) }

        return categories.sortedFavorite()
    }
}
