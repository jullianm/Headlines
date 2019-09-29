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
    @State var showSafariVC = false
    
    let article: Article?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Image(systemName: "chevron.compact.down")
                    .accentColor(.gray)
                    .opacity(0.2)
                Spacer()
            }
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text(article?.title ?? "")
                        .font(.system(size: 25))
                        .fontWeight(.black)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer(minLength: 20)
                  
                    Image(uiImage: self.imageLoader.image ?? UIImage(named: "news")!)
                        .modifier(uiImage: self.imageLoader.image ?? UIImage(named: "news")!)
                    
                    Spacer(minLength: 20)
                    
                    Text(article?.content ?? "")
                        .font(.system(size: 22))
                        .fontWeight(.medium)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer(minLength: 20)
                    
                    HStack(alignment: .center) {
                        Text("Source: ")
                        Text(article?.source.name ?? "")
                    }
                    HStack(alignment: .top) {
                        Text("Link: ")
                        
                        Button(action: {
                            self.showSafariVC = true
                        }) {
                            Text(article?.url ?? "").truncationMode(.middle)
                        }.sheet(isPresented: self.$showSafariVC, content: {
                            SafariView(url: URL(string: self.article?.url ?? "")!)
                        })
                    }
                }
            }
        }.padding()
    }
}
