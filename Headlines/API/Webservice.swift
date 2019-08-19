//
//  Webservice.swift
//  Headlight
//
//  Created by Jullianm on 15/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import Foundation
import Combine

typealias HeadlinesPublisher = (category: HeadlinesCategory, publisher: AnyPublisher<[Root], Error>)

class Webservice {
    
    private let _data = CurrentValueSubject<[Category], Error>([])
    
    var categories: Publishers.Sequence<[Category], Error> {
        return Publishers.Sequence(sequence: _data.value)
    }
    
    func fetch(headlines: Headlines) {
        
        let publishers = headlines.categories.map { category -> HeadlinesPublisher in
            
            let endpoint = Endpoint.search(
                sortedBy: headlines.type == .top ? .top: .everything,
                matching: .today,
                sortedBy: category.name.rawValue,
                matching: nil
            )
            
            let publisher = URLSession.shared.dataTaskPublisher(for: endpoint.url!)
            .retry(2)
            .map { $0.data }
            .decode(type: [Root].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            
            return (category: category.name, publisher)

        }
        
        zip(publishers: publishers)
        
    }
    
    private func zip(publishers: [HeadlinesPublisher]) {
        switch publishers.count {
        case 0:
            break
        case 1:
            //FIXME: TO DO
            break
        case 2:
            Publishers.Zip(
                publishers[0].publisher, publishers[1].publisher
            ).receive(subscriber: Subscribers.Sink(receiveCompletion: { _ in }, receiveValue: { value in

                self._data.send([
                    Category(name: publishers[0].category, isFavorite: true),
                    Category(name: publishers[1].category, isFavorite: true)
                ])
                
            }))
        case 3:
            Publishers.Zip3(
                publishers[0].publisher, publishers[1].publisher, publishers[2].publisher
            )
        case 4:
            Publishers.Zip4(
                publishers[0].publisher, publishers[1].publisher, publishers[2].publisher, publishers[3].publisher
            )
        case 5:
            Publishers.Zip4(
                publishers[0].publisher, publishers[1].publisher, publishers[2].publisher, publishers[3].publisher
            ).map { $0 }.zip(publishers[4].publisher)
        default:
            Publishers.Zip4(
                publishers[0].publisher, publishers[1].publisher, publishers[2].publisher, publishers[3].publisher
            ).map { $0 }.zip(publishers[4].publisher, publishers[5].publisher)
        }
    }

}


