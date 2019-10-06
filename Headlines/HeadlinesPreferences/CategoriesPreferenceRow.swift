//
//  CategoriesPreferenceRow.swift
//  Headlines
//
//  Created by Jullianm on 15/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

struct CategoriesPreferenceRow: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var name: String
    var isFavorite = false
    var isSelected = false
    
    var onButtonTapped: () -> ()
    var onFavoriteTapped: () -> ()
    
    var body: some View {
        HStack {
            Button(action: {
                self.onButtonTapped()
            }) {
                Image(systemName: isSelected ? "checkmark.square": "square")
                .accentColor(colorScheme == .light ? Color.blue: Color.white)
            }
            .accentColor(Color.black)
            
            Text(name)
            
            Spacer()
            
            Image(systemName: isFavorite ? "star.fill": "star")
                .onTapGesture { self.onFavoriteTapped() }
                .imageScale(.medium)
                .foregroundColor(.yellow)
            
        }
    }
}

#if DEBUG
struct CategoriesPreferenceRow_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesPreferenceRow(name: "", onButtonTapped: {
            
        }) {
            
        }
    }
}
#endif
