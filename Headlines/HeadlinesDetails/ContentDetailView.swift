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
                    
                    Spacer()
                    
                    Text(article?.publishedDate ?? "")
                        .font(.system(size: 17))
                        .fontWeight(.medium)
                    
                    Spacer(minLength: 20)
                  
                    Image(uiImage: self.imageLoader.image ?? UIImage(named: "headlines_placeholder")!)
                        .modifier(uiImage: self.imageLoader.image ?? UIImage(named: "headlines_placeholder")!)
                    
                    Spacer(minLength: 20)
                    
                    Text(article?.content ?? "")
                        .font(.system(size: 22))
                        .fontWeight(.medium)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer(minLength: 20)
                    
                    HStack(alignment: .center) {
                        Text("Source: ")
                        
                        Button(action: {
                            UIApplication.shared.open(URL(string: self.article?.url ?? "")!)
                        }) {
                            Text(article?.source.name.lowercased() ?? "")
                                .truncationMode(.middle)
                        }
                    }
                }
            }
        }.padding()
    }
}
