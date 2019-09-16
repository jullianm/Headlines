//
//  ListMode.swift
//  Headlight
//
//  Created by Jullianm on 29/07/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

struct HeaderView: View {
    var category: HeadlinesCategory
    
    var body: some View {
        Group {
            HStack {
                Text(category.name == .filtered ? "": category.name.rawValue.capitalizingFirstLetter())
                    .font(.system(size: 30))
                    .fontWeight(.semibold)
                
                if category.isFavorite {
                    Image(systemName: "star.fill")
                        .imageScale(.medium)
                        .foregroundColor(.yellow)
                }
            }
            .frame(height: 50)
        }
    }
}


