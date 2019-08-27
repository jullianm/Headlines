//
//  ContentView.swift
//  Headlight
//
//  Created by Jullianm on 27/07/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

enum Recency: String, CaseIterable {
    case today = "Today"
    case yesterday = "Yesterday"
    case threeDays = "3 days"
    case sevenDays = "7 days"
}

enum Mode {
    case list
    case image
}

struct ContentView: View {
    
    @ObservedObject var viewModel = HeadlinesViewModel(preferences: UserPreferences())
    
    @State private var mode: Mode = .image
    @State private var isSearching = false
    @State private var keyword = ""
    @State private var showPreferencesModal = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                
                if self.isSearching {
                    TextField("Search for articles, posts, headlines..", text: $keyword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .animation(.easeInOut(duration: 0.5))
                }
            
                List {
                    ForEach(viewModel.categories, id: \.name) { category in
                        Section {
                            if self.mode == .image {
                                VStack(alignment: .leading) {
                                    HeaderView(category: category)
                                    ReusableCollectionView(
                                        category: category,
                                        section: category.name,
                                        delegate: ReusableCollectionViewDelegate(section: category.name)
                                    )
                                }.frame(height: category.isFavorite ? 400: 300)
                            } else {
                                HeaderView(category: category)
                                ForEach(category.articles, id: \.title) { article in
                                    ArticleRow(article: article)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Headlines"), displayMode: .inline)
            .navigationBarItems(leading:
                Button(action: {
                    withAnimation {
                        self.mode = (self.mode == .list) ? .image: .list
                    }
                }) {
                    Image(systemName: (self.mode == .list) ? "list.bullet.below.rectangle": "list.bullet")
                        .accentColor(Color.black)
                }
                , trailing:
                HStack(spacing: 10) {
                    Button(action: {
                        self.showPreferencesModal = true
                    }) {
                        Image(systemName: "selection.pin.in.out")
                            .accentColor(Color.black)
                    }
                    
                    Button(action: {
                        withAnimation {
                            self.isSearching.toggle()
                        }
                    }) {
                        Image(systemName: "magnifyingglass")
                            .accentColor(isSearching ? Color.gray: Color.black)
                    }
                }
            )
        }
        .sheet(
            isPresented: $showPreferencesModal,
            onDismiss: {
                self.showPreferencesModal = false
        }, content: {
            PreferencesView(viewModel: self.viewModel)
        })
        
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: HeadlinesViewModel(preferences: UserPreferences()))
    }
}
#endif
