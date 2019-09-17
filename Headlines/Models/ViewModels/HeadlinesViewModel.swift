//
//  HeadlinesViewModel.swift
//  Headlines
//
//  Created by Jullianm on 18/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import Foundation
import Combine

class HeadlinesViewModel: ObservableObject, ViewModel {
    var webService: Webservice
    var preferences: UserPreferences
    
    let objectWillChange = ObservableObjectPublisher()
    
    var data: [HeadlinesCategory] = [] {
        willSet {
            if newValue.count > 0 {
                objectWillChange.send()
                isLoading = false
            }
        }
    }
    
    var selectedArticle: Article?
    
    var isSearching: Bool = false {
        willSet {
            objectWillChange.send()
        }
    }
    
    var keyword: String = "" {
        willSet {
            guard newValue != "" else {
                data.removeAll(where: { $0.name == .filtered })
                objectWillChange.send()
                return
            }
            
            data.removeAll(where: { $0.name == .filtered })
            
            let articles = data.flatMap { $0.articles.filter { $0.title.contains(newValue) } }
            data.insert(.init(name: .filtered, isFavorite: false, articles: articles), at: 0)
            
            objectWillChange.send()
        }
    }
    var isLoading = true
    
    required init(service: Webservice = Webservice(), preferences: UserPreferences) {
        self.webService = service
        self.preferences = preferences
        
        setup()
    }
    
    func setup() {
        fire()
    }

    func fire() {
        isLoading = true

        webService.fetch(preferences: preferences).map { value -> [HeadlinesCategory] in
            return self.preferences.categories.map { category -> HeadlinesCategory in
                let matched = value.first(where: { $0.0 == category.name })
                var cat = category
                cat.articles = matched?.1.articles ?? []

                return cat
            }
        }.receive(subscriber: Subscribers.Sink(
            receiveCompletion: { _ in },
            receiveValue: { value in
                self.data = value
        }))
    }    
}

extension HeadlinesViewModel {
    func update(pref: UserSelection) {
        preferences.country = pref.country
            .first(where: { $0.isSelected })?
            .country ?? .france
        
        preferences.categories = pref.categories
            .filter { $0.isSelected }
            .map { HeadlinesCategory(name: $0.name, isFavorite: $0.isFavorite) }
            .sortedFavorite()
        
        preferences.recency = pref.recency
        
        fire()
        
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


