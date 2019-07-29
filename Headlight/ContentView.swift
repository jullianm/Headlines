//
//  ContentView.swift
//  Headlight
//
//  Created by Jullianm on 27/07/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var shouldDisplayList = false
    @State private var sortByDate = 0
    
    var body: some View {
        NavigationView {
            VStack {
                SegmentedControl(selection: $sortByDate) {
                    Text("Today").tag(0)
                    Text("Yesterday").tag(1)
                    Text("3 days").tag(3)
                    Text("7 days").tag(7)
                }
                List {
                    if shouldDisplayList {
                        ListViewMode()
                    } else {
                        ImageViewMode()
                    }
                }
            }
            .navigationBarTitle(Text("Headlines"))
            .navigationBarItems(trailing:
                Button(action: {
                    self.shouldDisplayList.toggle()
                }) {
                    Image(systemName: self.shouldDisplayList ? "list.bullet.below.rectangle": "list.bullet")
                    .accentColor(Color.black)
                })
        }
        
    }
}

struct ImageViewMode: View {
    var body: some View {
        Group {
            VStack(alignment: .leading) {
                Text("Breaking news")
                .font(.system(size: 30))
                .fontWeight(.semibold)
                BreakingNewsCollectionView()
                .frame(height: 400)
            }
            VStack(alignment: .leading) {
                Text("Tech")
                .font(.system(size: 30))
                .fontWeight(.semibold)
                TechCollectionView()
                .frame(height: 200)
            }
            VStack(alignment: .leading) {
                Text("Economics")
                .font(.system(size: 30))
                .fontWeight(.semibold)
                EconomicsCollectionView()
                .frame(height: 200)
            }
            VStack(alignment: .leading) {
                Text("Politics")
                .font(.system(size: 30))
                .fontWeight(.semibold)
                PoliticsCollectionView()
                .frame(height: 200)
            }
            VStack(alignment: .leading) {
                Text("Science")
                .font(.system(size: 30))
                .fontWeight(.semibold)
                ScienceCollectionView()
                .frame(height: 200)
            }
        }
    }
}

struct ListViewMode: View {
    var body: some View {
        Group {
            VStack(alignment: .leading) {
                Text("Breaking news")
                .font(.system(size: 30))
                .fontWeight(.semibold)
                Text("blablablabla")
                .font(.system(size: 20))
                .fontWeight(.medium)
            }
            VStack(alignment: .leading) {
                Text("Tech")
                .font(.system(size: 30))
                .fontWeight(.semibold)
                Text("blablablabla")
                .font(.system(size: 20))
                .fontWeight(.medium)
            }
            VStack(alignment: .leading) {
                Text("Economics")
                .font(.system(size: 30))
                .fontWeight(.semibold)
                Text("blablablabla")
                .font(.system(size: 20))
                .fontWeight(.medium)
            }
            VStack(alignment: .leading) {
                Text("Politics")
                .font(.system(size: 30))
                .fontWeight(.semibold)
                Text("blablablabla")
                .font(.system(size: 20))
                .fontWeight(.medium)
            }
            VStack(alignment: .leading) {
                Text("Science")
                .font(.system(size: 30))
                .fontWeight(.semibold)
                Text("blablablabla")
                .font(.system(size: 20))
                .fontWeight(.medium)
            }
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
