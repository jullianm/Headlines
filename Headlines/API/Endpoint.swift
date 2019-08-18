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
    static func search(sortedBy sorting: Sorting = .top,
                       matching recency: Recency = .today,
                       matching keyword: String? = nil) -> Endpoint {
        
        var items: [URLQueryItem] = []
        
        return Endpoint(
            path: "/\(sorting.rawValue)",
            queryItems: items
        )
    }
}
extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "newsapi.org/v2"
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
}
