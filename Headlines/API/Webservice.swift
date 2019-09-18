//
//  Webservice.swift
//  Headlight
//
//  Created by Jullianm on 15/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import Foundation
import Combine

typealias HeadlinesResult = AnyPublisher<(HeadlinesSection, Root), Error>

class Webservice {    
     func fetch(preferences: UserPreferences) -> AnyPublisher<[(HeadlinesSection, Root)], Never> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let publishers = preferences.categories.map { category -> HeadlinesResult in

            let endpoint = Endpoint.search(
                recency: preferences.recency,
                country: preferences.country,
                category: category.name.rawValue
            )

            let publisher = URLSession.shared.dataTaskPublisher(for: endpoint.url!)
                .retry(2)
                .map { $0.data }
                .decode(type: Root.self, decoder: decoder)
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

