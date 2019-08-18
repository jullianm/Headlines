//
//  Webservice.swift
//  Headlight
//
//  Created by Jullianm on 15/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import Foundation
import Combine

class Webservice {
    func fetch(endpoint: Endpoint) -> some Publisher {
        
        guard let url = endpoint.url else {
            fatalError("URL should be valid.")
        }
        
        let publisher = URLSession.shared.dataTaskPublisher(for: url)
            .retry(2)
            .map { $0.data }
            .decode(type: [Root].self, decoder: JSONDecoder())
        
        return publisher
        
    }
}


