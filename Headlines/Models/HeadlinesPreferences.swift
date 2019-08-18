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
            viewModel.fire(endpoint: Endpoint.search(
                sortedBy: headlines.type == .top ? .top: .everything,
                matching: .today,
                matching: nil)
            )
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
                    category: $0.name,
                    isFavorite: $0.isFavorite
                )
        }

        return Headlines(
            type: selectedType,
            categories: selectedCategories
        )
    }
    
}

private struct Headlines {
    let type: HeadlinesType
    let categories: [Category]
}

private struct Category {
    let category: HeadlinesSection
    let isFavorite: Bool
}
