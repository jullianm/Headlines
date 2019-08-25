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
    let country: Country
    var categories: [Category]
    
    init(type: HeadlinesType = .top, country: Country = .france, categories: [Category] = []) {
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

class Category: ObservableObject {
    var name: HeadlinesCategory = .business
    var isFavorite: Bool = false
    @Published var articles: [Article]
    
    init(name: HeadlinesCategory, isFavorite: Bool, articles: [Article] = []) {
        self.name = name
        self.isFavorite = isFavorite
        self.articles = articles
    }
}
