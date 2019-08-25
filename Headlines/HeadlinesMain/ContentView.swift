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

struct ContentView: View {
    
    @ObservedObject var viewModel: HeadlinesViewModel
    
    @State private var shouldDisplayList = false
    @State private var sortByRecency = 0
    @State private var isSearching = false
    @State private var keyword = ""
    @State private var showPreferencesModal = false
        
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    TextField("Search for articles, posts, headlines..", text: $keyword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .transition(.scale)
                        .opacity(isSearching ? 1: 0)
                        .animation(.easeInOut(duration: 0.3))
                    
                    Picker(
                        selection: $sortByRecency,
                        label: Text("")) {
                            ForEach(0..<Recency.allCases.count, id: \.self) {
                                Text(Recency.allCases[$0].rawValue).tag($0)
                            }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .opacity(isSearching ? 0: 1)
                    .animation(.easeInOut(duration: 0.5))
                    
                }
                
                List {
                    if shouldDisplayList {
                        ListMode(categories: viewModel.categories)
                    } else {
                        ImageMode(categories: viewModel.categories)
                    }
                }
            }
            .navigationBarTitle(Text("Headlines"), displayMode: .inline)
            .navigationBarItems(leading:
                Button(action: {
                    withAnimation {
                        self.shouldDisplayList.toggle()
                    }
                }) {
                    Image(systemName: self.shouldDisplayList ? "list.bullet.below.rectangle": "list.bullet")
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
                        self.isSearching.toggle()
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

//#if DEBUG
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(preferences: HeadlinesPreferences(viewModel: HeadlinesViewModel()))
//    }
//}
//#endif
