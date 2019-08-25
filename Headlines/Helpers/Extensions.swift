//
//  Extensions.swift
//  Headlight
//
//  Created by Jullianm on 16/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import Foundation
import UIKit
import Combine

// MARK: - String
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

// MARK: - Array
extension Array where Element: Identifiable {

    var firstIndex: (UUID, _ matches: Bool) -> Index {
        
        return { value, matches in
            self.firstIndex { identifiable in
                matches ?
                    identifiable.id.hashValue == value.hashValue:
                    identifiable.id.hashValue != value.hashValue
                } ?? 0
        }
    }
}

extension Array where Element == PreferencesCategory {
    func sortedFavorite() -> [PreferencesCategory] {
        guard let index = self.firstIndex(where: { $0.isFavorite }) else {
            return self
        }
        
        var arr = self
        
        arr.remove(at: index)
        arr.insert(self[index], at: 0)
        
        return arr
    }
}
extension Array where Element == Category {
    func sortedFavorite() -> [Category] {
        guard let index = self.firstIndex(where: { $0.isFavorite }) else {
            return self
        }
        
        var arr = self
        
        arr.remove(at: index)
        arr.insert(self[index], at: 0)
        
        return arr
    }
}

// MARK: UIImageView

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleToFill) {  
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
