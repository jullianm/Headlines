//
//  UserDefaults.swift
//  Headlines
//
//  Created by Jullianm on 01/09/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import Foundation

struct UserDefaultsManager {    
    @UserDefaultWrapper("headlinesCategories", value: .technology)
    static var headlinesCategories: HeadlinesSection
    
    @UserDefaultWrapper("headlinesCountry", value: .france)
    static var headlinesCountry: HeadlinesCountry
    
    @UserDefaultWrapper("headlinesRecency", value: .today)
    static var headlinesRecency: HeadlinesRecency
    
}
