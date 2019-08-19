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
    
    required init(service: Webservice = Webservice()) {
        self.webService = service
    }
    
    func fire(headlines: Headlines) {
    
        
    }
}
