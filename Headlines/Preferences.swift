//
//  Preferences.swift
//  Headlight
//
//  Created by Jullianm on 16/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI
import Combine

class Preferences: ObservableObject {
    
    @Published var categories = PreferencesCategory.all
    
    var type = PreferencesHeadlines.all
    var country = Country.france
    
//    var headlines: Headlines {
//
//        let selectedType = type.filter { $0.isSelected }.first?.type ?? .top
//
//        let selectedCategories = categories
//            .filter { $0.isSelected }
//            .map {
//                Category(
//                    category: $0.name,
//                    isFavorite: $0.isFavorite
//                )
//        }
//
//        return Headlines(
//            type: selectedType,
//            categories: selectedCategories
//        )
//    }
    
}

struct Headlines {
    let type: HeadlinesType
    let categories: [Category]
}

struct Category {
    let category: HeadlinesSection
    let isFavorite: Bool
}
