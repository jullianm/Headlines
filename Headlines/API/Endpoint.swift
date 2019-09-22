//
//  Endpoint.swift
//  Headlines
//
//  Created by Jullianm on 18/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import Foundation

enum Sorting: String {
    case top = "top-headlines"
}

struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem]
    
    private static let apiKey = "your_api_key"
}

extension Endpoint {
    static func search(recency: HeadlinesRecency = .today,
                       country: HeadlinesCountry,
                       category: String) -> Endpoint {
        
        let items: [URLQueryItem] = [
            .init(name: "country", value: country.convert),
            .init(name: "category", value: category),
            .init(name: "from", value: recency.fromTo.from.format()),
            .init(name: "to", value: recency.fromTo.to.format()),
            .init(name: "apiKey", value: apiKey)
        ]
        
        return Endpoint(
            path: "/v2/\(Sorting.top.rawValue)",
            queryItems: items
        )
    }
}
extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "newsapi.org"
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
}
