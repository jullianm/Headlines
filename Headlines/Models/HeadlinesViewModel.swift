//
//  HeadlinesViewModel.swift
//  Headlines
//
//  Created by Jullianm on 18/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import Foundation

class HeadlinesViewModel: ViewModel {
    
    let webService: Webservice
    
    init(service: Webservice = Webservice()) {
        self.webService = service
    }
    
    func fire(endpoint: Endpoint) {
        
    }
    
}
