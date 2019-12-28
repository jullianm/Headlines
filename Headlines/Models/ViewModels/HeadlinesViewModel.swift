//
//  HeadlinesViewModel.swift
//  Headlines
//
//  Created by Jullianm on 18/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import Foundation
import UIKit
import Combine

final class HeadlinesViewModel: ObservableObject, ViewModel {
    /// Properties
    var webService: Webservice
    var selectedArticle: Article?
    var isFirstLaunch = true
    var keyword = CurrentValueSubject<String, Never>("")
    var canReloadData = false
    
    /// Cancellable object
    private var cancellable: Set<AnyCancellable>
    
    /// Published properties
    @Published var preferences: UserPreferences
    @Published var headlines: [Headlines] = []
    @Published var isLoading = false
    @Published var isRefreshing = false
    @Published var recencyIndex: Int = 0
    @Published var countryIndex: Int = 0
    @Published var canSearch = false
    
    required init(service: Webservice = Webservice(), preferences: UserPreferences) {
        self.webService = service
        self.preferences = preferences
        self.cancellable = Set()
        self.recencyIndex = preferences.recencies
            .first(where: { $0.isSelected })?
            .date.rawValue ?? 0
        self.countryIndex = preferences.countries
            .first(where: { $0.isSelected })?
            .country.rawValue ?? 0
        
        bind()
        fire()
    }
    
    /// Bindings
    func bind() {
        keyword
            .eraseToAnyPublisher()
            .dropFirst()
            .sink { str in
                if str != "" && !self.canSearch {
                    self.canSearch = true
                } else if str == "" && self.canSearch {
                    self.canSearch = false
                }
        }.store(in: &cancellable)
        
        self.$recencyIndex
            .sink(receiveValue: { self.setRecency(forIndex: $0) })
            .store(in: &cancellable)
        
        self.$isRefreshing
            .sink(receiveValue: { if $0 { self.fire() } })
            .store(in: &cancellable)
    }
    
    /// API calls
    func fire() {
        let data = webService.fetch(preferences: preferences, keyword: keyword.value).map { value -> [Headlines] in
            let headlines = value.map { (section, result) -> Headlines in
                let isFavorite = self.preferences.categories
                    .first(where: { $0.name == section })?
                    .isFavorite
                
                return Headlines(name: section, isFavorite: isFavorite ?? false, articles: result.articles)
            }
            
            return headlines.sortedFavorite()
        }
        .map { headlines in
            headlines.filter { $0.articles.count > 0 }
        }
        .handleEvents(receiveSubscription: { _ in
            self.isLoading = true
        }, receiveOutput: { value in
            self.isLoading = false
            self.canReloadData = true
            self.isRefreshing = false
            self.isFirstLaunch = false
        })
        .receive(on: DispatchQueue.main)
        .assign(to: \HeadlinesViewModel.headlines, on: self)
        
        cancellable.insert(data)
    }
    
    deinit {
        cancellable.forEach { $0.cancel() }
    }
}

/// Preferences updates
extension HeadlinesViewModel {    
    func setRecency(forIndex index: Int) {
        preferences.recencies.enumerated().forEach { (i, value) in
            self.preferences.recencies[i].isSelected = false
        }
        preferences.recencies[index].isSelected = true
    }
}

// Updating our models
extension HeadlinesViewModel {
    func update(selection: Selection) {
        switch selection {
        case let .category(category, isFavorite: isFavorite):
            
            let matchingIndex = preferences.categories.firstIndex(category.id)
            
            if isFavorite {
                
                preferences.categories[matchingIndex].isSelected = true
                preferences.categories[matchingIndex].isFavorite.toggle()
                
                for (index, _) in preferences.categories.enumerated() where matchingIndex != index {
                    preferences.categories[index].isFavorite = false
                }
                
            } else {
                preferences.categories[matchingIndex].isSelected.toggle()
                
                if category.isSelected {
                    preferences.categories[matchingIndex].isFavorite = false
                }
            }
        case let .country(index):
            
            for (i, _) in preferences.countries.enumerated() where index != i {
                preferences.countries[i].isSelected = false
            }
            
            preferences.countries[index].isSelected = true
        }
        
    }
}
/// User defaults storage
extension HeadlinesViewModel {
    func save() {
        UserDefaultsManager.preferencesCategories = preferences.categories
        UserDefaultsManager.preferencesCountry = preferences.countries
        UserDefaultsManager.preferencesRecency = preferences.recencies
    }
}
