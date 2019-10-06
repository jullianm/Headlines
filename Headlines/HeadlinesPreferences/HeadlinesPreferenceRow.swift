//
//  HeadlinesPreferenceRow.swift
//  Headlines
//
//  Created by Jullianm on 15/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

struct HeadlinesPreferenceRow: View {
    
    var name: String
    var isSelected: Bool
    var onButtonTapped: () -> ()
    
    var body: some View {
        HStack {
            Button(action: {
                if !self.isSelected {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        self.onButtonTapped()
                    }
                }
            }) {
                Image(systemName: "circle.fill")
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.black, lineWidth: 0.2)
                )
            }
            .accentColor(Color.blue.opacity(isSelected ? 1: 0.5))
            
            Text(name)
            
            Spacer()
            
        }
        
    }
}

#if DEBUG
struct HeadlinesPreferenceRow_Previews: PreviewProvider {
    static var previews: some View {
        HeadlinesPreferenceRow(name: "Top", isSelected: false) {
            
        }
    }
}
#endif
