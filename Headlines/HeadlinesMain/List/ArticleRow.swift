//
//  ListNewsRow.swift
//  Headlines
//
//  Created by Jullianm on 30/07/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

struct CategoryRow: View {
    let model: HeadlinesViewModel
    let section: HeadlinesSection
    let shouldReloadData: Bool
    let handler: (Bool) -> ()
    
    var body: some View {
        ReusableCollectionView(
            viewModel: model,
            section: section,
            shouldReloadData: shouldReloadData,
            handler: handler
        )
    }
}

struct ArticleRow: View {
    
    let article: Article
    @Environment(\.colorScheme) var colorScheme
    let viewModel: HeadlinesViewModel
    let showDetails: (Bool) -> ()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.article.title)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.init(arrayLiteral: .leading, .trailing))
            HStack(alignment: .center) {
                Spacer()
            Text(self.article.source.name.lowercased())
                .font(.system(size: 17))
                .fontWeight(.ultraLight)
                .padding(.init(arrayLiteral: .leading, .trailing))
            }
            Divider()
        }
        .onTapGesture {
            self.viewModel.selectedArticle = self.article
            self.showDetails(true)
        }
    }
}

