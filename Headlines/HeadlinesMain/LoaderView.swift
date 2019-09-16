//
//  LoaderView.swift
//  Headlines
//
//  Created by Jullianm on 28/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    
    var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct LoaderView<Content>: View where Content: View {
    
    var isShowing: Bool
    var content: () -> Content
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                
                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 8 : 0)
                
                ActivityIndicator(isAnimating: self.isShowing, style: .large)
                    
                    .frame(width: geometry.size.width / 4, height: geometry.size.height / 7.5)
                    .background(Color.gray.opacity(0.5))
                    .foregroundColor(Color.primary)
                    .cornerRadius(20)
                    .opacity(self.isShowing ? 1 : 0)
                
            }
        }
    }
    
}

