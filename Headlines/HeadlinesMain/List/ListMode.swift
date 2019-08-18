//
//  ListMode.swift
//  Headlight
//
//  Created by Jullianm on 29/07/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

struct ListMode: View {
    
    var categories: [PreferencesCategory]
    
    var body: some View {
        Group {
            
            ForEach(self.categories, id: \.id) { category in
                Section {
                    VStack(alignment: .leading) {
                        HStack {
                            
                            Text(category.name.rawValue.capitalizingFirstLetter())
                            
                            if category.isFavorite {
                                
                                Image(systemName: "star.fill")
                                    .imageScale(.medium)
                                    .foregroundColor(.yellow)
                            }
                            
                        }
                        
                        ListNewsRow()
                        ListNewsRow()
                        ListNewsRow()
                        
                    }
                }
            }
            
        }
    }
}
#if DEBUG
struct ListMode_Previews: PreviewProvider {
    static var previews: some View {
        ListMode(categories: [])
    }
}
#endif

