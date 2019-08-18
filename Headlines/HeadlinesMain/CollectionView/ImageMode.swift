//
//  ImageMode.swift
//  Headlight
//
//  Created by Jullianm on 29/07/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

struct ImageMode: View {
    
    var categories: [PreferencesCategory]
    
    var body: some View {
        Group {
            
            ForEach(self.categories, id: \.id) { category in
                
                VStack(alignment: .leading) {
                    HStack {
                        
                        Text(category.name.rawValue.capitalizingFirstLetter())
                            .font(.system(size: 30))
                            .fontWeight(.semibold)
                        
                        
                        if category.isFavorite {
                            
                            Image(systemName: "star.fill")
                                .imageScale(.medium)
                                .foregroundColor(.yellow)
                            
                        }
                        
                    }
                    
                    ReusableCollectionView(section: category.name)
                }.frame(height: category.isFavorite ? 400: 200)
                
            }
        }
    }
}


#if DEBUG
struct ImageMode_Previews: PreviewProvider {
    static var previews: some View {
        ImageMode(categories: [])
    }
}
#endif
