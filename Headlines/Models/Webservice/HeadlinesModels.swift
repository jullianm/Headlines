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
    let country: HeadlinesCountry
    var categories: [HeadlinesCategory]
    
    init(country: HeadlinesCountry = .france, categories: [HeadlinesCategory] = []) {
        self.country = country
        self.categories = categories
    }
    
    static var all: Headlines {
        let categories = HeadlinesSection.allCases.map {
            HeadlinesCategory(name: $0, isFavorite: $0 == .technology)
        }
                
        return Headlines(
            country: .france,
            categories: categories.sortedFavorite()
        )
    }
}

struct HeadlinesCategory: Identifiable {
    let id = UUID()
    var name: HeadlinesSection = .business
    var isFavorite: Bool = false
    var articles: [Article]
    
    init(name: HeadlinesSection, isFavorite: Bool, articles: [Article] = []) {
        self.name = name
        self.isFavorite = isFavorite
        self.articles = articles
    }
    
    static var all: [HeadlinesCategory] {
        let categories = PreferencesCategory.all
            .filter { $0.isSelected }
            .map { HeadlinesCategory(name: $0.name, isFavorite: $0.isFavorite) }

        return categories.sortedFavorite()
    }
}
