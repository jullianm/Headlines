//
//  HeadlinesViewModel.swift
//  Headlines
//
//  Created by Jullianm on 18/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import Foundation
import Combine

class HeadlinesViewModel: ViewModel {
    var webService: Webservice
    
    private let headlinesSubject = PassthroughSubject<Headlines, Error>()
    
    var headlinesPublisher: AnyPublisher<Headlines, Error> {
        return headlinesSubject.eraseToAnyPublisher()
    }
    
    required init(service: Webservice = Webservice()) {
        webService = service
    }
    
    func bind(headlines: Headlines) {
        Publishers.Zip4(
            webService.businessSubject,
            webService.entertainmentSubject,
            webService.politicsSubject,
            webService.scienceSubject
        )
            .map { $0 }
            .zip(webService.sportsSubject, webService.technologySubject, webService.healthSubject)
            .map { ($0.0.0, $0.0.1, $0.0.2, $0.0.3, $0.1, $0.2, $0.3) }
            .map { result in
                var updated = headlines
                
                headlines.categories.enumerated().forEach { (index, category) in
                    let result = [result.0, result.1, result.2, result.3, result.4, result.5, result.6].first(where: { $0.category == category.name })
                    updated.categories[index].model = result?.result
                }
                return updated
        }
        .receive(subscriber: AnySubscriber(headlinesSubject))
    }
    
    func fire(headlines: Headlines) {
        webService.fetch(headlines: headlines)
    }
}

