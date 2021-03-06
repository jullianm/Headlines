//
//  HeadlinesModels.swift
//  Headlines
//
//  Created by Jullianm on 18/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import Foundation

// MARK: - Root
public struct Result: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
public class Article: Codable, Identifiable {
    public var id = UUID()
    let source: Source
    let author: String?
    private let rawTitle: String
    let articleDescription: String?
    let url: String
    let urlToImage: String?
    private let publishedAt: Date
    private let rawContent: String?
    
    var title: String {
        guard
            let index = rawTitle.lastIndex(where: { $0 == "-" }) else {
            return rawTitle
        }
        var formattedContent = rawTitle 
        formattedContent.removeSubrange(index..<formattedContent.endIndex)
        
        return formattedContent
    }
    
    var publishedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        formatter.locale = Locale.current
        
        enum CountryCode: String {
            case fr
        }
        
        if NSLocale.preferredLanguages[0].starts(with: "fr") {
            formatter.dateFormat = "EEEE, d MMM yyyy"
        } else {
            formatter.dateFormat = "EEEE, MMM d yyyy"
        }
        
        return formatter
            .string(from: publishedAt)
            .capitalizingFirstLetter()
    }
    
    var content: String {
        guard let index = rawContent?.firstIndex(where: { $0 == "[" }) else {
            return rawContent ?? ""
        }
        var formattedContent = rawContent ?? ""
        formattedContent.removeSubrange(index..<formattedContent.endIndex)
        
        return formattedContent
    }

    enum CodingKeys: String, CodingKey {
        case source, author
        case rawTitle = "title"
        case articleDescription = "description"
        case rawContent = "content"
        case url, urlToImage, publishedAt
    }
}

// MARK: - Source
public struct Source: Codable {
    let id: String?
    let name: String
}
