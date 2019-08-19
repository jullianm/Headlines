//
//  HeadlinesPreferences.swift
//  Headlight
//
//  Created by Jullianm on 16/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI
import Combine

class HeadlinesPreferences: ObservableObject {
    
    let viewModel: ViewModel
    
    var type = PreferencesHeadlines.all
    var country = Country.france
    
    @Published var categories = PreferencesCategory.all {
        didSet {
            
//            viewModel.fire(endpoint: endpoint, categories: headlines.categories)
            // TODO: Implement Publishers.Zip6 to fetch data from WS
        }
    }
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    private var headlines: Headlines {

        let selectedType = type.filter { $0.isSelected }.first?.type ?? .top

        let selectedCategories = categories
            .filter { $0.isSelected }
            .map {
                Category(
                    name: $0.name,
                    isFavorite: $0.isFavorite
                )
        }

        return Headlines(
            type: selectedType,
            country: country,
            categories: selectedCategories
        )
    }
    
}

struct Headlines {
    let type: HeadlinesType
    let country: Country
    let categories: [Category]
}

struct Category {
    let name: HeadlinesCategory
    let isFavorite: Bool
    let model: [Root] = []
}
struct Post: Codable {
    let userID, id: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}
