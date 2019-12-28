//
//  ContentView.swift
//  Headlines
//
//  Created by Jullianm on 27/07/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

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
        static let refreshImg = "arrow.clockwise"
        static let searchImg = "magnifyingglass"
    }
}

struct ContentView: View {
    @EnvironmentObject var navigator: Navigator
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var viewModel = HeadlinesViewModel(preferences: UserPreferences())
    
    @State private var mode: Mode = .image
    @State private var isSearching = false 
    @State private var scaleValue = 0.0
    
    enum Mode {
        case list, image
        
        mutating func toggle() {
            self = (self == .list) ? .image: .list
        }
    }
        
    var body: some View {
        GeometryReader { geometry in
            LaunchView(isFirstLaunch: self.viewModel.isFirstLaunch) {
                LoaderView(isShowing: (self.viewModel.isLoading && !self.viewModel.isRefreshing) && !self.viewModel.isFirstLaunch) {
                    NavigationView {
                        VStack(alignment: .leading) {
                            VStack(alignment: .center) {
                                // Search area
                                HStack(alignment: .center) {
                                    self.searchTextField
                                    self.keywordButton
                                }
                                Divider()
                                    .accentColor(Color.black.opacity(0.3))
                                    .frame(height: 0.3, alignment: .top)
                            }
                            .padding(.top)
                            .frame(height: self.isSearching ? 50: 0)
                            .scaleEffect(self.isSearching ? 1 : 0)
                            
                            // Headlines area
                            ZStack {
                                self.buildScrollView()
                                self.buildFloatingButton()
                            }
                        }
                        .navigationBarTitle(Text(Constants.Text.title), displayMode: .inline)
                        .navigationBarItems(
                            leading: self.modeButton,
                            trailing: HStack(spacing: 17) {
                                self.refreshButton.padding(.trailing, 5)
                                self.searchButton
                            }
                        )
                    }
                }
            }
        }
        .sheet(isPresented: $navigator.showSheet,
               onDismiss: { self.navigator.showSheet = false },
               content: {
                if self.navigator.presenting == .details {
                    self.contentDetailView
                } else {
                    self.preferencesView
                }
        })
    }
    
    // MARK: - Sheet presentation
    private var contentDetailView: some View {
        ContentDetailView(
            imageLoader: ImageLoader(model: self.viewModel),
            article: self.viewModel.selectedArticle
        )
    }
    
    private var preferencesView: some View {
        PreferencesView(viewModel: self.viewModel)
    }
    
    // MARK: - Textfield
    private var searchTextField: some View {
        TextField(Constants.Text.keyword.localized(), text: self.$viewModel.keyword.value) {
            guard self.viewModel.keyword.value != "" else {
                return
            }
            self.viewModel.fire()
            UIApplication.shared.endEditing()
        }
        .padding(.leading)
        .keyboardType(.webSearch)
        .textFieldStyle(PlainTextFieldStyle())
    }
    
    // MARK: - Buttons
    private var modeButton: some View {
        Button(action: {
            self.mode.toggle()
        }) {
            Image(systemName: (self.mode == .list) ? Constants.Image.bulletBelowImg: Constants.Image.bulletImg)
                .resizable()
                .aspectRatio(self.mode == .image ? 1.25: 1, contentMode: .fit)
                .accentColor(colorScheme == .light ? Color.black: Color.white)
        }.frame(width: 20, height: 20)
    }
    
    private var refreshButton: some View {
        Button(action: {
            self.viewModel.fire()
        }) {
            Image(systemName: Constants.Image.refreshImg)
                .resizable()
                .aspectRatio(0.9, contentMode: .fit)
                .accentColor(colorScheme == .light ? Color.black: Color.white)
        }
        .frame(width: 20, height: 20)
    }
    
    private var searchButton: some View {
        Button(action: {
            withAnimation {
                self.isSearching.toggle()
                UIApplication.shared.endEditing()
            }
        }) {
            Image(systemName: Constants.Image.searchImg)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .accentColor(self.isSearching ? Color.gray: colorScheme == .light ? Color.black: Color.white)
        }.frame(width: 20, height: 20)
    }
    
    private var preferencesButton: some View {
        Button(action: {
            self.navigator.presenting = .preferences
        }, label: {
            ZStack {
                Circle()
                    .frame(width: 67, height: 60)
                    .foregroundColor(self.colorScheme == .dark ? Color.white: Color.black)
                    .padding(.bottom, 7)
                
                Image(systemName: Constants.Image.preferencesImg)
                    .resizable()
                    .aspectRatio(0.7, contentMode: .fit)
                    .accentColor(self.colorScheme == .dark ? Color.black: Color.white)
                    .padding(.bottom, 7)
                    .frame(width: 30, height: 30)
            }
            
        })
    }
    
    private var keywordButton: some View {
        Button(action: {
            self.viewModel.fire()
        }) {
            Image(systemName: "checkmark")
                .accentColor(self.viewModel.canSearch ? Color.blue :Color.gray)
                .frame(width: 20, height: 20)
        }
        .disabled(!self.viewModel.canSearch)
        .padding(.trailing)
    }
    
    // MARK: - Scroll view area
    private func buildScrollView() -> some View {
        ScrollView {
            if self.viewModel.headlines.isEmpty {
                HStack {
                    Image(systemName: Constants.Image.searchImg)
                    Text(Constants.Text.noResults.localized())
                        .fontWeight(.regular)
                }.padding(.top, 10.0)
            } else {
                ForEach(self.viewModel.headlines) { category in
                    self.getScrollViewContent(forMode: self.mode, headlines: category)
                }
            }
        }
    }
    private func getScrollViewContent(forMode mode: Mode, headlines: Headlines) -> some View {
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
                }.frame(height: headlines.isFavorite ? 400: 300)
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
    private func buildFloatingButton() -> some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                self.preferencesButton
                    .cornerRadius(38.5)
                    .padding()
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
