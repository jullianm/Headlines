//
//  ViewModel.swift
//  Headlines
//
//  Created by Jullianm on 18/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import Foundation
import Combine

protocol ViewModel {
    var webService: Webservice { get set }
    var headlinesPublisher: AnyPublisher<Headlines, Error> { get }
    
    init(service: Webservice)
    
    func fire(headlines: Headlines)
    func bind(headlines: Headlines)
}
