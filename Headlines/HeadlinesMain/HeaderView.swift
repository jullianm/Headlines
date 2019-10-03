//
//  ListMode.swift
//  Headlight
//
//  Created by Jullianm on 29/07/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

struct HeaderView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var headlines: Headlines
    
    var body: some View {
        Group {
            HStack {
                if headlines.name == .search {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .accentColor(colorScheme == .light ? .black: .white)
                }
                
                Text(headlines.name.rawValue.capitalizingFirstLetter())
                    .font(.system(size: 30))
                    .fontWeight(.semibold)
                                
                if headlines.isFavorite {
                    Image(systemName: "star.fill")
                        .imageScale(.medium)
                        .foregroundColor(.yellow)
                }
            }
            .frame(height: 50)
        }
    }
}


