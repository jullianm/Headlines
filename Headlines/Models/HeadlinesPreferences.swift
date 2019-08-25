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
    
    var viewModel: ViewModel
    
    // MARK: Preferences selection
    var type = PreferencesHeadlines.all
    var country = Country.france
    
    // Update preferences on screen
    @Published var categories = PreferencesCategory.all
    
    // MARK: Model
    // Update model
    @Published var headlines: Headlines = Headlines()
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        bind()
        trigger(headlines: Headlines.all)
    }
    
    private func bind() {
        viewModel.headlinesPublisher.receive(
            subscriber: Subscribers.Sink(receiveCompletion: { _ in }, receiveValue: { value in
                self.headlines = value
            })
        )
    }
    
    func update() {
        let selectedType = type.filter { $0.isSelected }.first?.type ?? .top

        let selectedCategories = categories
            .filter { $0.isSelected }
            .map { Category(name: $0.name, isFavorite: $0.isFavorite) }

        let headlines = Headlines(type: selectedType, country: country, categories: selectedCategories)
    
        trigger(headlines: headlines)
    }
    
    private func trigger(headlines: Headlines) {
        viewModel.bind(headlines: headlines)
        viewModel.fire(headlines: headlines)
    }
    
}
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
            Category(name: $0, isFavorite: $0 == .technology, model: nil)
        }
                
        return Headlines(
            type: .top,
            country: .france,
            categories: categories.sortedFavorite()
        )
    }
}

struct Category {
    var name: HeadlinesCategory = .business
    var isFavorite: Bool = false
    var model: Root? = nil
}
