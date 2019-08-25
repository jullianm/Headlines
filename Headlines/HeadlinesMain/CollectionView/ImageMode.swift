//
//  ImageMode.swift
//  Headlight
//
//  Created by Jullianm on 29/07/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

struct ImageMode: View {
    
    var categories: [Category]
    
    var body: some View {
        Group {
            
            ForEach(self.categories, id: \.name) { category in
                
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
                    
                    ReusableCollectionView(category: category, delegate: ReusableCollectionViewDelegate(section: category.name))
                }.frame(height: category.isFavorite ? 400: 300)
                
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
