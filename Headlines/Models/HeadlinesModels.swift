//
//  HeadlinesModels.swift
//  Headlines
//
//  Created by Jullianm on 18/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import Foundation

// MARK: - Root
public struct Root: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
public struct Article: Codable {
    let source: Source
    let author, title, articleDescription: String
    let url, urlToImage: String
    let publishedAt: Date
    let content: String

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}

// MARK: - Source
public struct Source: Codable {
    let id, name: String
}
