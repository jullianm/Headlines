//
//  PreferencesView.swift
//  Headlight
//
//  Created by Jullianm on 15/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

enum Selection {
    case category(PreferencesCategory, isFavorite: Bool)
    case country(Int)
}

struct PreferencesView: View {
    
    @Environment(\.presentationMode) var presentation
    @ObservedObject var viewModel: HeadlinesViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Recency")
                    .font(.system(size: 20))
                    .fontWeight(.semibold)) {
                        Picker(
                            selection: self.$viewModel.recencyIndex,
                            label: Text("")) {
                                ForEach(0..<viewModel.preferences.recencies.count, id: \.self) {
                                    Text(self.viewModel.preferences.recencies[$0].date.rawValue).tag($0)
                                }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Country")
                    .font(.system(size: 20))
                    .fontWeight(.semibold)) {
                        
                        CountryPreferenceRow { value in
                            self.viewModel.update(selection: .country(value))
                        }
                }
                
                Section(header:
                    Text("Categories")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)) {
                            
                            ForEach(viewModel.preferences.categories, id: \.id) { category in
                                
                                CategoriesPreferenceRow(
                                    name: category.name.rawValue.capitalizingFirstLetter(),
                                    isFavorite: category.isFavorite,
                                    isSelected: category.isSelected,
                                    onButtonTapped: {
                                        self.viewModel.update(selection: .category(category, isFavorite: false))
                                }) { // on favorite tapped
                                    self.viewModel.update(selection: .category(category, isFavorite: true))
                                }
                            }.padding()
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Preferences", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    self.viewModel.fire()
                    self.presentation.wrappedValue.dismiss()
                }) {
                    Image(systemName: "checkmark")
                        .accentColor(Color.blue)
                }
            )
        }
    }
}


#if DEBUG
struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView(
            viewModel: HeadlinesViewModel(preferences: UserPreferences()))
    }
}
#endif
