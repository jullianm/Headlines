//
//  HeadlinesViewModel.swift
//  Headlines
//
//  Created by Jullianm on 18/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import Foundation
import Combine

final class HeadlinesViewModel: ObservableObject, ViewModel {
    var webService: Webservice
    var selectedArticle: Article?
    var isFirstLaunch = true
    
    private var cancellable: Set<AnyCancellable>
    
    @Published var preferences: UserPreferences
    @Published var headlines: [Headlines] = []
    @Published var isLoading = false
    @Published var isRefreshing = false
    @Published var keyword: String = "" 
    @Published var recencyIndex: Int = 0
    
    required init(service: Webservice = Webservice(), preferences: UserPreferences) {
        self.webService = service
        self.preferences = preferences
        self.cancellable = Set()
        
        bind()
        fire()
    }
    
    func bind() {
        self.$keyword
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { self.sortArticles(byKeyword: $0) }
            .store(in: &cancellable)
        
        self.$recencyIndex
            .sink(receiveValue: { self.setRecency(forIndex: $0) })
            .store(in: &cancellable)
        
        self.$isRefreshing
            .sink(receiveValue: { if $0 { self.fire() } })
            .store(in: &cancellable)
    }
    
    func fire() {
        let data = webService.fetch(preferences: preferences).map { value -> [Headlines] in
            let headlines = value.map { (section, result) -> Headlines in
                let isFavorite = self.preferences.categories
                    .first(where: { $0.name == section })?
                    .isFavorite
                
                return Headlines(name: section, isFavorite: isFavorite ?? false, articles: result.articles)
            }
            
            return headlines.sortedFavorite()
        }
        .handleEvents(receiveSubscription: { _ in
            self.isLoading = true
        }, receiveOutput: { _ in
            self.isLoading = false
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

extension HeadlinesViewModel {
    private func sortArticles(byKeyword keyword: String) {
        guard keyword != "" else {
            headlines.removeAll(where: { $0.name == .filtered })
            return
        }
        headlines.removeAll(where: { $0.name == .filtered })
        
        let articles = headlines.flatMap { $0.articles.filter { $0.title.contains(keyword) } }
        headlines.insert(.init(name: .filtered, isFavorite: false, articles: articles), at: 0)
    }
    
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
