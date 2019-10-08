//
//  ContentView.swift
//  Headlines
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
            static let noResults = "No results found..."
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
                LoaderView(isShowing: (self.viewModel.isLoading && !self.viewModel.isRefreshing) && !self.viewModel.isFirstLaunch) {
                    NavigationView {
                        VStack(alignment: .leading) {
                            if self.isSearching {
                                VStack(alignment: .center) {
                                    HStack(alignment: .center) {
                                        TextField(Constants.Text.keyword.localized(), text: self.$viewModel.keyword.value) {
                                            guard self.viewModel.keyword.value != "" else { return }
                                            self.viewModel.fire()
                                            UIApplication.shared.endEditing()
                                        }
                                        .padding(.leading)
                                        .keyboardType(.webSearch)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .animation(.linear(duration: 0.17))
                                        
                                        Button(action: {
                                            self.viewModel.fire()
                                        }) {
                                            Image(systemName: "checkmark")
                                                .accentColor(self.viewModel.canSearch ? Color.blue :Color.gray)
                                                .frame(width: 20, height: 20)
                                        }
                                        .disabled(!self.viewModel.canSearch)
                                        .padding(.trailing)
                                        .animation(.linear(duration: 0.17))
                                    }
                                    Divider()
                                        .accentColor(Color.black.opacity(0.3))
                                        .frame(height: 0.3, alignment: .top)
                                        .animation(.linear(duration:
                                            0.1))
                                }
                                .padding(.top)
                                .transition(.move(edge: .top))
                                
                            }
                            
                            self.scrollView
                        }
                        .navigationBarTitle(Text(Constants.Text.title), displayMode: .inline)
                        .navigationBarItems(
                            leading: self.modeButton,
                            trailing: HStack(spacing: 17) {
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
    
    private var searchTextField: some View {
        TextField(Constants.Text.keyword, text: self.$viewModel.keyword.value)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .animation(.easeInOut(duration: 0.5))
    }
    
    private var scrollView: some View {
        RefreshableScrollView(height: 70, refreshing: self.$viewModel.isRefreshing) {
            if self.viewModel.headlines.isEmpty {
                HStack {
                    Image(systemName: Constants.Image.searchImg)
                    Text(Constants.Text.noResults.localized())
                        .fontWeight(.regular)
                }.padding(.top, 10.0)
            } else {
                ForEach(self.viewModel.headlines) { category in
                    self.buildScrollViewContent(forMode: self.mode, headlines: category)
                }
            }
        }
    }
    
    private var modeButton: some View {
        Button(action: {
            self.mode = (self.mode == .list) ? .image: .list
        }) {
            Image(systemName: (self.mode == .list) ? Constants.Image.bulletBelowImg: Constants.Image.bulletImg)
                .resizable()
                .aspectRatio(self.mode == .image ? 1.25: 1, contentMode: .fit)
                .accentColor(colorScheme == .light ? Color.black: Color.white)
        }.frame(width: 20, height: 20)
    }
    
    private var preferencesButton: some View {
        Button(action: {
            self.navigator.presenting = .preferences
        }) {
            Image(systemName: Constants.Image.preferencesImg)
                .resizable()
                .aspectRatio(0.7, contentMode: .fit)
                .accentColor(colorScheme == .light ? Color.black: Color.white)
        }.frame(width: 25, height: 25)
    }
    
    private var searchButton: some View {
        Button(action: {
            withAnimation(.linear(duration: 0.2)) {
                self.isSearching.toggle()
                
                if !self.isSearching && self.viewModel.keyword.value == "" {
                    self.viewModel.fire()
                }
            }
        }) {
            Image(systemName: Constants.Image.searchImg)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .accentColor(self.isSearching ? Color.gray: colorScheme == .light ? Color.black: Color.white)
        }.frame(width: 20, height: 20)
    }
    
    private func buildScrollViewContent(forMode mode: Mode, headlines: Headlines) -> some View {
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
        }.animation(.linear(duration: mode == .list ? 0.2: 0.05))
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
