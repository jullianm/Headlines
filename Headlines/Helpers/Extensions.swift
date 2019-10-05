//
//  Extensions.swift
//  Headlight
//
//  Created by Jullianm on 16/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import Combine

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension Array where Element: Identifiable {
    var firstIndex: (_ matching: UUID) -> Index {
        return { value in
            self.firstIndex { identifiable in
                identifiable.id.hashValue == value.hashValue
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
extension Array where Element == Headlines {
    func sortedFavorite() -> [Headlines] {
        guard let index = self.firstIndex(where: { $0.isFavorite }) else {
            return self
        }
        
        var arr = self
        
        arr.remove(at: index)
        arr.insert(self[index], at: 0)
        
        return arr
    }
}

extension Date {
    static var today: Date { return Date() }
    static var yesterday: Date { return Date().dayBefore }
    static var threeDaysAgo: Date { return Date().threeDaysAgo }
    static var sevenDaysAgo: Date { return Date().threeDaysAgo }

    private var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    private var threeDaysAgo: Date {
        return Calendar.current.date(byAdding: .day, value: -3, to: self)!
    }
    private var sevenDaysAgo: Date {
        return Calendar.current.date(byAdding: .day, value: -7, to: self)!
    }
    
    func format() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringDate = dateFormatter.string(from: self)
        return stringDate
    }
}

extension Image {
    func modifier(uiImage : UIImage) -> some View {
        return self
            .resizable()
            .aspectRatio(uiImage.size.width/uiImage.size.height, contentMode: .fill)
            .frame(width: UIScreen.main.bounds.width - 40, height: 250.0, alignment: .leading)
            .cornerRadius(10.0)
    }
}

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
