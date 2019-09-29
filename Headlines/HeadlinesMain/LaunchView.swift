//
//  LaunchView.swift
//  Headlines
//
//  Created by Jullianm on 28/09/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

struct LaunchView<Content: View>: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    let isFirstLaunch: Bool
    let content: () -> Content
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                self.content()
                
                if self.isFirstLaunch {
                    ZStack {
                        Rectangle()
                            .foregroundColor(self.colorScheme == .light ? Color.white: Color.black)
                            .edgesIgnoringSafeArea(.all)
                        Image("splash_headlines")
                            .resizable()
                            .frame(width: geometry.size.width/3, height: geometry.size.width/3, alignment: .center)
                            .cornerRadius(10.0)
                            
                    }
                }
            }
        }
    }
}

