//
//  CountryPreferenceRow.swift
//  Headlight
//
//  Created by Jullianm on 17/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

struct CountryPreferenceRow: View {
    @ObservedObject var viewModel: HeadlinesViewModel
    @State private var showPicker = false
    
    private let countries = HeadlinesCountry.allCases
    let action: (_ value: Int) -> ()
    
    var body: some View {
        
        // FIXME: ugly workaround to be able to trigger the callback when the picker value changed
        let indexBinding = Binding(get: {
            self.viewModel.countryIndex
        }, set: {
            self.viewModel.countryIndex = $0
            self.action($0)
        })
        
        return Group {
            HStack {
                Button(action: {
                    withAnimation {
                        self.showPicker.toggle()
                    }
                }) {
                    Image(systemName: "chevron.right.circle")
                        .accentColor(Color.blue.opacity(showPicker ? 0.7: 1))
                        .imageScale(.large)
                        .rotationEffect(.degrees(showPicker ? 90 : 0))
                        .scaleEffect(showPicker ? 1.3 : 1)
                        .padding()
                }
                
                Text(countries[viewModel.countryIndex].label.capitalizingFirstLetter())
            }
            
            if showPicker {
                HStack {
                    Spacer()
                    
                    Picker(selection: indexBinding, label: Text("")) {
                        ForEach(0..<countries.count) { value in
                            Text(self.countries[value].label.capitalizingFirstLetter()).tag(value)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    
                    Spacer()
                }
            }
        }
    }
}
