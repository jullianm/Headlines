//
//  ContentView.swift
//  Headlight
//
//  Created by Jullianm on 27/07/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    enum Mode {
        case list
        case image
    }
    
    @ObservedObject var viewModel = HeadlinesViewModel(preferences: UserPreferences())
    
    @State private var mode: Mode = .image
    @State private var isSearching = false
    @State private var keyword = ""
    @State private var showPreferencesModal = false
    
    private var shouldReloadData: Bool {
        return !showPreferencesModal
    }
   
    private var isShowing: Bool {
        return viewModel.isLoading
    }
    
    var body: some View {
        LoaderView(isShowing: isShowing) {
            NavigationView {
                VStack(alignment: .leading) {
                    
                    if self.isSearching {
                        TextField("Search for articles, posts, headlines..", text: self.$keyword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .animation(.easeInOut(duration: 0.5))
                    }
                    
                    List {
                        ForEach(self.viewModel.categories, id: \.name) { category in
                            Section {
                                if self.mode == .image {
                                    VStack(alignment: .leading) {
                                        HeaderView(category: category)
                                        ReusableCollectionView(
                                            viewModel: self.viewModel,
                                            section: category.name,
                                            shouldReloadData: self.shouldReloadData
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
                                .accentColor(self.isSearching ? Color.gray: Color.black)
                        }
                    }
                )
            }
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
