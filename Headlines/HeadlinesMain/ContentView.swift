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
    @Environment(\.colorScheme) var colorScheme: ColorScheme
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
        GeometryReader { geometry in
            LaunchView(isFirstLaunch: self.viewModel.isFirstLaunch) {
                LoaderView(isShowing: self.viewModel.isLoading && !self.viewModel.isFirstLaunch) {
                    NavigationView {
                        VStack(alignment: .leading) {
                            if self.isSearching {
                                TextField(Constants.Text.keyword, text: self.$viewModel.keyword)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .animation(.easeInOut(duration: 0.5))
                            }
                            ScrollView(.vertical, showsIndicators: false) {
                                if self.isSearching && self.viewModel.keyword != "" {
                                    self.content(forMode: self.mode, headlines: self.viewModel.headlines[0])
                                } else {
                                    ForEach(self.viewModel.headlines) { category in
                                        self.content(forMode: self.mode, headlines: category)
                                    }
                                }
                            }
                        }
                        .navigationBarTitle(Text(Constants.Text.title), displayMode: .inline)
                        .navigationBarItems(
                            leading: self.modeButton,
                            trailing: HStack(spacing: 10) {
                                self.preferencesButton.padding(.trailing, 5)
                                self.searchButton
                            }
                        )
                    }
                }
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
                .accentColor(colorScheme == .light ? Color.black: Color.white)
        }
    }
    
    var preferencesButton: some View {
        Button(action: {
            self.navigator.presenting = .preferences
        }) {
            Image(systemName: Constants.Image.preferencesImg)
                .accentColor(colorScheme == .light ? Color.black: Color.white)
        }
    }
    
    var searchButton: some View {
        Button(action: {
            withAnimation { self.isSearching.toggle() }
        }) {
            Image(systemName: Constants.Image.searchImg)
                .accentColor(self.isSearching ? Color.gray: colorScheme == .light ? Color.black: Color.white)
        }
    }
    
    func content(forMode mode: Mode, headlines: Headlines) -> some View {
        Group {
            if mode == .image {
                VStack(alignment: .leading) {
                    HeaderView(headlines: headlines).padding(.leading)
                    CategoryRow(
                        model: self.viewModel,
                        section: headlines.name,
                        shouldReloadData: !self.navigator.showSheet,
                        handler: { _ in self.navigator.presenting = .details }
                    )
                }
                    .frame(height: headlines.isFavorite ? 400: 300)
                    .scaledToFill()
                    .clipped()
            } else {
                VStack(alignment: .leading) {
                    HeaderView(headlines: headlines)
                    ForEach(headlines.articles) { article in
                        ArticleRow(article: article, viewModel: self.viewModel) { _ in self.navigator.presenting = .details }
                    }
                }.padding(.leading)
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
