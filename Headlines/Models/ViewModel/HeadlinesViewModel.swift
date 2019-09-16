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
        bind()
        fire()
    }

    func bind() {
        Publishers.Zip4(
            webService.businessSubject,
            webService.entertainmentSubject,
            webService.politicsSubject,
            webService.scienceSubject
        )
            .map { $0 }
            .zip(webService.sportsSubject, webService.technologySubject, webService.healthSubject)
            .map { result -> Headlines in
                let data = self.processData(result: result)
                
                var headlines = Headlines(country: self.preferences.country, categories: self.preferences.categories)
                
                headlines.categories.enumerated().forEach { (index, category) in

                    let category = data.first(where: { $0.category == category.name })

                    headlines.categories[index].articles = category?.result?.articles ?? []
                    
                }
               
                return headlines
                
                
        }.receive(subscriber: Subscribers.Sink(receiveCompletion: { _ in }, receiveValue: { value in
            self.data = value.categories
        }))
        
    }
    
    func fire() {
        isLoading = true
        webService.fetch(preferences: preferences)
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


extension HeadlinesViewModel {
    private func processData(result: ((HeadlinesResult, HeadlinesResult, HeadlinesResult, HeadlinesResult), HeadlinesResult, HeadlinesResult, HeadlinesResult)) -> [HeadlinesResult] {
        
        let data = [result.0.0, result.0.1, result.0.2, result.0.3, result.1, result.2, result.3]
        
        return data.filter { $0.result != nil }
        
    }
}
