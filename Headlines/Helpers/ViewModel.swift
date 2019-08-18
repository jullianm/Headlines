//
//  ViewModel.swift
//  Headlines
//
//  Created by Jullianm on 18/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import Foundation

protocol ViewModel {
    var webService: Webservice { get set }
    init(service: Webservice)
    func fire(endpoint: Endpoint)
}
