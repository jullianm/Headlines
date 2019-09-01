//
//  UserPreferences.swift
//  Headlight
//
//  Created by Jullianm on 16/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

struct UserPreferences {
    var type: HeadlinesType = .top
    var country: HeadlinesCountry = .france
    var categories: [Category] = Category.all
    var recency: HeadlinesRecency = .today
}

