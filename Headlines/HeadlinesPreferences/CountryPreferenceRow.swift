//
//  CountryPreferenceRow.swift
//  Headlight
//
//  Created by Jullianm on 17/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

struct CountryPreferenceRow: View {
    
    @State private var countryIndex: Int = 0
    @State private var showPicker = false
    
    private let countries = Country.allCases
    let action: (_ value: Int) -> ()
    
    var body: some View {
        
        // FIXME: ugly workaround to be able to trigger the callback when the picker value changed
        let indexBinding = Binding(get: {
            self.countryIndex
        }, set: {
            self.countryIndex = $0
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
                        .imageScale(.large)
                        .rotationEffect(.degrees(showPicker ? 90 : 0))
                        .scaleEffect(showPicker ? 1.5 : 1)
                        .padding()
                }
                
                Text(
                    countries[countryIndex].rawValue.capitalizingFirstLetter()
                )
                
            }
            
            if showPicker {
                HStack {
                    Spacer()
                    
                    Picker(selection: indexBinding, label: Text("")) {
                        ForEach(0..<countries.count) { value in
                            Text(self.countries[value].rawValue.capitalizingFirstLetter()).tag(value)
                            
                            
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    
                    Spacer()
                }
            }
        }
    }
}

#if DEBUG
struct CountryPreferenceRow_Previews: PreviewProvider {
    static var previews: some View {
        CountryPreferenceRow { value in
            
        }
    }
}
#endif
