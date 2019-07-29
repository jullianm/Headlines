//
//  ContentView.swift
//  Headlight
//
//  Created by Jullianm on 27/07/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

struct ContentView: View {
        
    var body: some View {
        NavigationView {
            List {
                VStack(alignment: .leading) {
                    Text("Breaking news")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    
                    BreakingNewsCollectionView()
                    .frame(height: 400)
                }
                VStack(alignment: .leading) {
                    Text("Tech")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    
                    TechCollectionView()
                    .frame(height: 200)
                }
                VStack(alignment: .leading) {
                    Text("Economics")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    
                    EconomicsCollectionView()
                    .frame(height: 200)
                }
                VStack(alignment: .leading) {
                    Text("Politics")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    
                    PoliticsCollectionView()
                    .frame(height: 200)
                }
                VStack(alignment: .leading) {
                    Text("Science")
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    
                    ScienceCollectionView()
                    .frame(height: 200)
                }
            }
            .navigationBarTitle(Text("Headlines"))
            .background(Color.yellow)
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
