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
    
    private static let apiKey = "f0a2af1e23e14f75b3cd3fd51b53e0b8"
}

extension Endpoint {
    static func search(recency: HeadlinesRecency = .today,
                       country: HeadlinesCountry,
                       category: String,
                       keyword: String) -> Endpoint {
        
        let items: [URLQueryItem] = [
            .init(name: "country", value: country.convert),
            .init(name: "category", value: category),
            .init(name: "q", value: keyword),
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
