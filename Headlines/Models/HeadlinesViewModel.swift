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
    var preferences: Preferences
    
    @Published var categories: [Category] = []
    
    required init(service: Webservice = Webservice(), preferences: Preferences) {
        self.webService = service
        self.preferences = preferences
        
        setup()
    }
    
    func setup() {
        bind()
        fire()
        
        #if DEBUG
        generateMock()
        #endif
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
                
                let categories = self.preferences.selectedCategories.map { Category(name: $0.name, isFavorite: $0.isFavorite) }
                
                let news = Headlines(type: self.preferences.selectedType, country: self.preferences.selectedCountry, categories: categories.sortedFavorite())
                
                news.categories.enumerated().forEach { (index, category) in

                    let category = data.first(where: { $0.category == category.name })

                    news.categories[index].articles = category?.result?.articles ?? []
                    
                }
               
                return news
                
                
        }.receive(subscriber: Subscribers.Sink(receiveCompletion: { _ in }, receiveValue: { value in
            self.categories = value.categories
        }))
        
    }
    
    func fire() {
        webService.fetch(preferences: preferences)
    }
    
    private func processData(result: ((HeadlinesResult, HeadlinesResult, HeadlinesResult, HeadlinesResult), HeadlinesResult, HeadlinesResult, HeadlinesResult)) -> [HeadlinesResult] {
        
        let data = [result.0.0, result.0.1, result.0.2, result.0.3, result.1, result.2, result.3]
        
        return data.filter { $0.result != nil }
        
    }
}

extension HeadlinesViewModel {
    private func generateMock() {

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        guard
            let url = Bundle(for: Preferences.self).url(forResource: "top_headlines_mock", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let models = try? decoder.decode(Root.self, from: data) else {
                return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

            let categories = HeadlinesCategory.allCases.map {
                Category(name: $0, isFavorite: $0 == .business, articles: models.articles)
            }

            let headlines = Headlines(type: .top, country: .germany, categories: categories.sortedFavorite())
            
            self.categories = headlines.categories
        }
    }
}


