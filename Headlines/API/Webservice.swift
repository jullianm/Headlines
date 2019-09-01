//
//  Webservice.swift
//  Headlight
//
//  Created by Jullianm on 15/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import Foundation
import Combine

typealias HeadlinesPublisher = (category: HeadlinesCategory, publisher: AnyPublisher<Root, Error>)
typealias HeadlinesResult = (category: HeadlinesCategory, result: Root?)

class Webservice {
    
    let businessSubject = PassthroughSubject<HeadlinesResult, Error>()
    let politicsSubject = PassthroughSubject<HeadlinesResult, Error>()
    let technologySubject = PassthroughSubject<HeadlinesResult, Error>()
    let sportsSubject = PassthroughSubject<HeadlinesResult, Error>()
    let scienceSubject = PassthroughSubject<HeadlinesResult, Error>()
    let healthSubject = PassthroughSubject<HeadlinesResult, Error>()
    let entertainmentSubject = PassthroughSubject<HeadlinesResult, Error>()
    
    func fetch(preferences: UserPreferences) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let publishers = preferences.categories.map { category -> HeadlinesPublisher in
            
            let endpoint = Endpoint.search(
                sorting: preferences.type == .top ? .top: .everything,
                recency: preferences.recency,
                category: category.name.rawValue,
                country: preferences.country,
                keyword: nil
            )
            
            let publisher = URLSession.shared.dataTaskPublisher(for: endpoint.url!)
            .retry(2)
            .map { $0.data }
            .decode(type: Root.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            
            return (category: category.name, publisher)
        }
        
        process(publishers: publishers)
    }
    
    private func process(publishers: [HeadlinesPublisher]) {
        let categories = HeadlinesCategory.allCases
        
        categories.forEach { category in
            check(category: category, forPublishers: publishers)
        }
    }
    
    private func check(category: HeadlinesCategory, forPublishers publishers: [HeadlinesPublisher]) {
        if let publisher = publishers.first(where: { $0.category == category }) {
            publisher.publisher.receive(subscriber: Subscribers.Sink(receiveCompletion: { _ in }, receiveValue: { value in
                self.send(value: value, forCategory: category)
            }))
        } else {
            send(value: nil, forCategory: category)
        }
    }
    
    private func send(value: Root?, forCategory category: HeadlinesCategory) {
        switch category {
        case .sports:
            sportsSubject.send((category, value))
        case .technology:
            technologySubject.send((category, value))
        case .business:
            businessSubject.send((category, value))
        case .politics:
            politicsSubject.send((category, value))
        case .science:
            scienceSubject.send((category, value))
        case .health:
            healthSubject.send((category, value))
        case .entertainment:
            entertainmentSubject.send((category, value))
        }
    }
}

