//
//  ReusableCollectionView.swift
//  Headlight
//
//  Created by Jullianm on 16/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import UIKit
import SwiftUI

final class ReusableCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    
    var section: HeadlinesCategory
    
    init(section: HeadlinesCategory) {
        self.section = section
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

struct ReusableCollectionView: UIViewRepresentable {
    
    var viewModel: HeadlinesViewModel
    let section: HeadlinesCategory
    let delegate: ReusableCollectionViewDelegate
    let reloadData: Bool
    
    init(viewModel: HeadlinesViewModel, section: HeadlinesCategory, shouldReloadData: Bool = true) {
        self.viewModel = viewModel
        self.section = section
        self.delegate = ReusableCollectionViewDelegate(section: section)
        self.reloadData = shouldReloadData
    }
    
    func makeUIView(context: UIViewRepresentableContext<ReusableCollectionView>) -> UICollectionView {

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: CollectionViewFlowLayout()
        )
        
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.delegate = delegate

        collectionView.register(UINib(nibName: "\(ArticleCell.self)", bundle: .main), forCellWithReuseIdentifier: "\(ArticleCell.self)")
                
        let dataSource = UICollectionViewDiffableDataSource<HeadlinesCategory, HeadlinesContainer>(collectionView: collectionView) { collectionView, indexPath, container in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ArticleCell.self)", for: indexPath) as? ArticleCell
            
            guard let category = self.viewModel.categories.first(where: { $0.name == self.section }) else {
                return cell
            }
            
            cell?.configure(article: category.articles[indexPath.item])
            
            return cell
            
        }
        
        populate(dataSource: dataSource)
        context.coordinator.dataSource = dataSource
        
        return collectionView
    }
    
    func updateUIView(_ uiView: UICollectionView, context: UIViewRepresentableContext<ReusableCollectionView>) {
        guard let dataSource = context.coordinator.dataSource else {
            return
        }
        populate(dataSource: dataSource)
    }
    
    func makeCoordinator() -> MainCoordinator {
        MainCoordinator()
    }
    
    func populate(dataSource: UICollectionViewDiffableDataSource<HeadlinesCategory, HeadlinesContainer>) {
        var snapshot = NSDiffableDataSourceSnapshot<HeadlinesCategory, HeadlinesContainer>()
        
        guard let category = self.viewModel.categories.first(where: { $0.name == self.section }), reloadData else {
            return
        }
        
        let containers = category.articles.map(HeadlinesContainer.init)
        
        snapshot.appendSections([category.name])

        snapshot.appendItems(containers)

        dataSource.apply(snapshot)
    }
    
}

enum HeadlinesCategory: String, CaseIterable {
    case sports
    case technology
    case business
    case politics
    case science
    case health
    case entertainment
}


final class HeadlinesContainer: Hashable {
    let id = UUID()
    var article: Article
    
    init(article: Article) {
        self.article = article
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: HeadlinesContainer, rhs: HeadlinesContainer) -> Bool {
        return lhs.id == rhs.id
    }
}

