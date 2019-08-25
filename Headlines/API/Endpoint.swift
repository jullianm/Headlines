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
    case everything = "everything"
}

struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem]
}

extension Endpoint {
    static func search(sorting: Sorting = .top,
                       recency: Recency = .today,
                       category: String? = nil,
                       country: Country,
                       keyword: String? = nil) -> Endpoint {
        
        let items: [URLQueryItem] = [
            .init(name: "country", value: country.convert),
            .init(name: "category", value: category),
            .init(name: "q", value: keyword),
            .init(name: "apiKey", value: "")
        ]
        
        
        return Endpoint(
            path: "/v2/\(sorting.rawValue)",
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
