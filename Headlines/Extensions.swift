//
//  Extensions.swift
//  Headlight
//
//  Created by Jullianm on 16/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

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
