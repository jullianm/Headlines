//
//  ContentDetailView.swift
//  Headlines
//
//  Created by Jullianm on 18/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

struct ContentDetailView: View {
    @ObservedObject var imageLoader: ImageLoader
    
    let article: Article?
    
    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    Image(systemName: "chevron.down")
                        .accentColor(.gray)
                        .opacity(0.2)
                    Spacer()
                }
            }
            Section {
                Text(article?.title ?? "")
                    .font(.system(size: 25))
                    .fontWeight(.black)
            }
            
            Section {
                if self.imageLoader.image != nil {
                    Image(uiImage: self.imageLoader.image!).format()
                } else {
                    Image("news").format()
                }
            }
            
            Section {
                Text(article?.content ?? "")
                    .font(.system(size: 22))
                    .fontWeight(.medium)
            }
            
            Section {
                HStack(alignment: .center) {
                    Text("Source: ")
                    Text(article?.source.name ?? "")
                }
            }
            
            Section {
                HStack(alignment: .top) {
                    Text("Link: ")
                    Text(article?.url ?? "")
                }
            }
        }
        .padding()
    }
}
