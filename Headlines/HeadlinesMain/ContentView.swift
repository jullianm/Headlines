//
//  ContentView.swift
//  Headlight
//
//  Created by Jullianm on 27/07/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var navigator: Navigator
    @ObservedObject var viewModel = HeadlinesViewModel(preferences: UserPreferences())
    
    @State private var mode: Mode = .image
    @State private var isSearching = false
    
    enum Mode {
        case list, image
    }
    
    private struct Constants {
        struct Text {
            static let keyword = "Search by keyword..."
            static let title = "Headlines"
        }
        struct Image {
            static let bulletBelowImg = "list.bullet.below.rectangle"
            static let bulletImg = "list.bullet"
            static let preferencesImg = "selection.pin.in.out"
            static let searchImg = "magnifyingglass"
        }
    }
    
    var body: some View {
        LoaderView(isShowing: viewModel.isLoading) {
            NavigationView {
                VStack(alignment: .leading) {
                    if self.isSearching {
                        TextField(Constants.Text.keyword, text: self.$viewModel.keyword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .animation(.easeInOut(duration: 0.5))
                    }
                    List {
                        if self.isSearching && self.viewModel.keyword != "" {
                            self.getContent(forMode: self.mode, category: self.viewModel.data[0])
                        } else {
                            ForEach(self.viewModel.data, id: \.name) { category in
                                self.getContent(forMode: self.mode, category: category)
                            }
                        }
                    }
                }
                .navigationBarTitle(Text(Constants.Text.title), displayMode: .inline)
                .navigationBarItems(
                    leading: self.modeButton,
                    trailing: HStack(spacing: 10) {
                        self.preferencesButton
                        self.searchButton
                    }
                )
            }
        }
        .sheet(
            isPresented: $navigator.showSheet,
            onDismiss: { self.navigator.showSheet = false }, content: {
                if self.navigator.presenting == .details {
                    ContentDetailView(
                        imageLoader: ImageLoader(model: self.viewModel),
                        article: self.viewModel.selectedArticle
                    )
                } else {
                    PreferencesView(viewModel: self.viewModel)
                }
        })
    }
    
    var modeButton: some View {
        Button(action: {
            withAnimation {
                self.mode = (self.mode == .list) ? .image: .list
            }
        }) {
            Image(systemName: (self.mode == .list) ? Constants.Image.bulletBelowImg: Constants.Image.bulletImg)
                .accentColor(Color.black)
        }
    }
    
    var preferencesButton: some View {
        Button(action: {
            self.navigator.presenting = .preferences
        }) {
            Image(systemName: Constants.Image.preferencesImg).accentColor(Color.black)
        }
    }
    
    var searchButton: some View {
        Button(action: {
            withAnimation { self.isSearching.toggle() }
        }) {
            Image(systemName: Constants.Image.searchImg).accentColor(self.isSearching ? Color.gray: Color.black)
        }
    }
    
    func getContent(forMode mode: Mode, category: HeadlinesCategory) -> some View {
        Section {
            if mode == .image {
                VStack(alignment: .leading) {
                    HeaderView(category: category)
                    CategoryRow(
                        model: self.viewModel,
                        section: category.name,
                        shouldReloadData: !self.navigator.showSheet,
                        handler: { _ in self.navigator.presenting = .details }
                    )
                }.frame(height: category.isFavorite ? 400: 300)
            } else {
                HeaderView(category: category)
                ForEach(category.articles, id: \.title) { article in
                    ArticleRow(article: article, viewModel: self.viewModel) { _ in self.navigator.presenting = .details }
                }
            }
        }
    }
}
