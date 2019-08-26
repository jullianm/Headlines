//
//  ListMode.swift
//  Headlight
//
//  Created by Jullianm on 29/07/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

struct ListMode: View {
    
    var viewModel: HeadlinesViewModel
    
    var body: some View {
        Group {
            
            ForEach(self.viewModel.categories, id: \.name) { category in
                Section {
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
        ListMode(viewModel: HeadlinesViewModel(preferences: UserPreferences()))
    }
}
#endif

