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
    var preferences: Preferences { get set }
    var categories: [Category] { get set }
    
    init(service: Webservice, preferences: Preferences)
    
    func setup()
    func fire()
    func bind()
}
