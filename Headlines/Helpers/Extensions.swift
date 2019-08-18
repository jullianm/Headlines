//
//  Extensions.swift
//  Headlight
//
//  Created by Jullianm on 16/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import Foundation
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

// MARK: - Combine
extension Publishers {
    public struct Zip6<A, B, C, D, E, F> : Publisher where A : Publisher, B : Publisher, C : Publisher, D : Publisher, E : Publisher, F: Publisher, A.Failure == B.Failure, B.Failure == C.Failure, C.Failure == D.Failure, D.Failure == E.Failure, E.Failure == F.Failure {

        public typealias Output = (A.Output, B.Output, C.Output, D.Output, E.Output, F.Output)
        public typealias Failure = A.Failure

        public let a: A
        public let b: B
        public let c: C
        public let d: D
        public let e: E
        public let f: F

        public init(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ f: F) {
            self.a = a
            self.b = b
            self.c = c
            self.d = d
            self.e = e
            self.f = f
        }

        public func receive<S>(subscriber: S) where S : Subscriber, D.Failure == S.Failure, S.Input == (A.Output, B.Output, C.Output, D.Output, E.Output, F.Output) {
            
        }
    }
}
