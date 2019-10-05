//
//  Webservice.swift
//  Headlight
//
//  Created by Jullianm on 15/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import Foundation
import Combine

typealias HeadlinesResult = AnyPublisher<(HeadlinesSection, Result), Error>

class Webservice {    
    func fetch(preferences: UserPreferences, keyword: String) -> AnyPublisher<[(HeadlinesSection, Result)], Never> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let recency = preferences.recencies.filter { $0.isSelected }.first?.date
        let country = preferences.countries.filter { $0.isSelected }.first?.country
        let categories = preferences.categories.filter { $0.isSelected }
        
        let publishers = categories.map { category -> HeadlinesResult in
            
            let endpoint = Endpoint.search(
                recency: recency ?? .today,
                country: country ?? .france,
                category: category.name.rawValue,
                keyword: keyword
                    .lowercased()
                    .folding(options: .diacriticInsensitive, locale: .current)
                    .trimmingCharacters(in: .whitespaces)
            )

            let publisher = URLSession.shared.dataTaskPublisher(for: endpoint.url!)
                .retry(2)
                .map { $0.data }
                .decode(type: Result.self, decoder: decoder)
                .receive(on: RunLoop.main)
                .map { (category.name, $0) }
                .eraseToAnyPublisher()

            return publisher
        }

        return Publishers.MergeMany(publishers)
            .collect()
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}

