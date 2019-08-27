//
//  ListNewsRow.swift
//  Headlight
//
//  Created by Jullianm on 30/07/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

struct ArticleRow: View {
    
    var article: Article
    
    var body: some View {
        HStack {
            Text(self.article.title)
            Spacer()
            Image(systemName: "chevron.right")
        }.padding()
        
    }
}

