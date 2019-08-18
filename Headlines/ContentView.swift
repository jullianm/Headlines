//
//  ContentView.swift
//  Headlight
//
//  Created by Jullianm on 27/07/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var preferences: Preferences
    
    @State private var shouldDisplayList = false
    @State private var sortByDate = 0
    @State private var isSearching = false
    @State private var query = ""
    @State private var showPreferencesModal = false
    
    enum Date: String {
        case today = "Today"
        case yesterday = "Yesterday"
        case threeDays = "3 days ago"
        case sevenDays = "7 days ago"
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    TextField("Search for articles, posts, headlines..", text: $query)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .transition(.scale)
                        .opacity(isSearching ? 1: 0)
                        .animation(.easeInOut(duration: 0.3))
                    
                    Picker(
                        selection: $sortByDate,
                        label: Text("")) {
                            
                            Text(Date.today.rawValue).tag(0)
                            Text(Date.yesterday.rawValue).tag(1)
                            Text(Date.threeDays.rawValue).tag(3)
                            Text(Date.sevenDays.rawValue).tag(7)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .opacity(isSearching ? 0: 1)
                    .animation(.easeInOut(duration: 0.5))
                    
                }
                
                List {
                    if shouldDisplayList {
                        ListMode(categories: preferences.categories)
                    } else {
                        ImageMode(categories: preferences.categories)
                    }
                }
            }
            .navigationBarTitle(Text("Headlines"), displayMode: .inline)
            .navigationBarItems(leading:
                Button(action: {
                    self.shouldDisplayList.toggle()
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
        }.sheet(
            isPresented: $showPreferencesModal,
            onDismiss: {
                self.showPreferencesModal = false
        }, content: {
            PreferencesView(preferences: self.preferences)
        })
        
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(preferences: Preferences())
    }
}
#endif
