//
//  PreferencesView.swift
//  Headlight
//
//  Created by Jullianm on 15/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

private enum Selection {
    case type(PreferencesHeadlines)
    case category(PreferencesCategory, favorite: Bool)
    case country(Int)
}

struct PreferencesView: View {
    
    @Environment(\.presentationMode) var presentation
    
    @State private var type = PreferencesHeadlines.all
    @State private var categories = PreferencesCategory.all
    @State private var countries = PreferencesCountry.all
    
    @State private var sortByRecency = 0
    
    var viewModel: HeadlinesViewModel
    
    var isAllSelected: Bool {
        return type.first(where: { $0.isSelected })?.type == .all
    }
    
    var selectedCountry = 0
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Recency")
                    .font(.system(size: 20))
                    .fontWeight(.semibold)) {
                        Picker(
                            selection: $sortByRecency,
                            label: Text("")) {
                                ForEach(0..<Recency.allCases.count, id: \.self) {
                                    Text(Recency.allCases[$0].rawValue).tag($0)
                                }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                }
                
                if !isAllSelected {
                    Section(header: Text("Country")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)) {

                            CountryPreferenceRow { value in
                                self.updatePreferences(selection: .country(value))
                            }
                    }
                }
                
                Section(header:
                    Text("Headlines")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)) {
                            
                            ForEach(type, id: \.id) { headline in
                                HeadlinesPreferenceRow(
                                    name: headline.type.rawValue.capitalizingFirstLetter(),
                                    isSelected: headline.isSelected) {
                                        
                                        self.updatePreferences(selection: .type(headline))
                                }
                            }.padding()
                }
                
                Section(header:
                    Text("Categories")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)) {
                            
                            ForEach(categories, id: \.id) { category in
                                
                                CategoriesPreferenceRow(
                                    name: category.name.rawValue.capitalizingFirstLetter(),
                                    isFavorite: category.isFavorite,
                                    isSelected: category.isSelected,
                                    onButtonTapped: {
                                        
                                        self.updatePreferences(selection: .category(category, favorite: false))
                                        
                                }) { // on favorite tapped
                                    
                                    self.updatePreferences(selection: .category(category, favorite: true))
                                    
                                }
                                
                            }.padding()
                }
                
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Preferences", displayMode: .inline)
            .navigationBarItems(trailing:
                
                Button(action: {
                    self.validate()
                    self.presentation.wrappedValue.dismiss()
                }) {
                    Image(systemName: "checkmark")
                        .accentColor(Color.blue)
                }
                
            )
        }
    }
    
    private func updatePreferences(selection: Selection) {
        switch selection {
            
        case let .type(headline):
            
            let matchingIndex = self.type.firstIndex(headline.id, true)
            let nonMatchingIndex = self.type.firstIndex(headline.id, false)
            
            self.type[matchingIndex].isSelected.toggle()
            self.type[nonMatchingIndex].isSelected = false
            
        case let .category(category, favorite: favorite):
            
            let matchingIndex = self.categories.firstIndex(category.id, true)
            
            if favorite {
                
                self.categories[matchingIndex].isSelected = true
                self.categories[matchingIndex].isFavorite.toggle()
                
                for (index, _) in self.categories.enumerated() where matchingIndex != index {
                    self.categories[index].isFavorite = false
                }
                
            } else {
                self.categories[matchingIndex].isSelected.toggle()
                
                if category.isSelected {
                    self.categories[matchingIndex].isFavorite = false
                }
            }
        case let .country(index):
            
            for (i, _) in self.countries.enumerated() where index != i {
                self.countries[i].isSelected = false
            }
            
            self.countries[index].isSelected = true
        }
        
    }
    
    private func validate() {
        viewModel.preferences.type = (type.filter { $0.isSelected }.first?.type) ?? .top
                
        viewModel.preferences.country = countries
            .first(where: { $0.isSelected })?
            .country ?? .france
        
        viewModel.preferences.categories = categories
            .filter { $0.isSelected }
            .map { Category(name: $0.name, isFavorite: $0.isFavorite) }
            .sortedFavorite()
        
        viewModel.fire()
    }
}

