//
//  ListMode.swift
//  Headlines
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
                Text(headlines.name.rawValue.capitalizingFirstLetter().localized())
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


