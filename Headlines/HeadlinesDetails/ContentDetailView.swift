//
//  ContentDetailView.swift
//  Headlines
//
//  Created by Jullianm on 18/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentDetailView: View {
    let article: Article?
    
    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    Image(systemName: "minus")
                        .accentColor(.gray)
                        .opacity(0.6)
                    Spacer()
                }
            }
            Section {
                Text(article?.title ?? "")
                    .font(.system(size: 25))
                    .fontWeight(.black)
            }
            
            Section {
                AnimatedImage(url: URL(string: article?.urlToImage ?? "")!)
                    .scaledToFit()
                    .frame(width: 200, height: 200, alignment: .center)
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

