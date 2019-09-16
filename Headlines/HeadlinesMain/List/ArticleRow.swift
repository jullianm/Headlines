//
//  ListNewsRow.swift
//  Headlight
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
    let viewModel: HeadlinesViewModel
    let showDetails: (Bool) -> ()
    
    var body: some View {
        HStack {
            Text(self.article.title)
            Spacer()
        }
        .padding()
        .onTapGesture {
            self.viewModel.selectedArticle = self.article
            self.showDetails(true)
        }
    }
}

