//
//  Endpoint.swift
//  Headlines
//
//  Created by Jullianm on 18/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import Foundation

struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem]
}

extension Endpoint {
    static func search(recency: HeadlinesRecency = .today,
                       country: HeadlinesCountry,
                       category: String,
                       keyword: String) -> Endpoint {
        
        var items: [URLQueryItem] = [
            .init(name: "country", value: country.convert),
        ]

        var path = "/rest/news/top/\(category)"
        
        if keyword.count > 0 {
            path.append("/search")
            items.append(.init(name: "keyword", value: keyword))
        }
        
        return Endpoint(
            path: path,
            queryItems: items
        )
    }
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.headlines.rankorr.red"
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
}
