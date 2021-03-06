//
//  ReusableCollectionView.swift
//  Headlines
//
//  Created by Jullianm on 16/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import UIKit
import SwiftUI

final class ReusableCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    
    let section: HeadlinesSection
    let viewModel: HeadlinesViewModel
    let showDetails: (Bool) -> ()
    
    init(section: HeadlinesSection, viewModel: HeadlinesViewModel, handler: @escaping (Bool) -> ()) {
        self.section = section
        self.viewModel = viewModel
        self.showDetails = handler
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let category = self.viewModel.headlines.first(where: { $0.name == self.section }) else { return }
        viewModel.selectedArticle = category.articles[indexPath.item]
        
        showDetails(true)
    }
}

struct ReusableCollectionView: UIViewRepresentable {
    private var viewModel: HeadlinesViewModel
    private let section: HeadlinesSection
    private let delegate: ReusableCollectionViewDelegate
    
    init(viewModel: HeadlinesViewModel, section: HeadlinesSection, handler: @escaping (Bool) -> ()) {
        self.viewModel = viewModel
        self.section = section
        
        self.delegate = ReusableCollectionViewDelegate(section: section,
                                                       viewModel: viewModel,
                                                       handler: handler)
    }
    
    func makeUIView(context: UIViewRepresentableContext<ReusableCollectionView>) -> UICollectionView {

        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: CollectionViewFlowLayout())
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = delegate
        
        collectionView.register(UINib(nibName: "\(ArticleCell.self)", bundle: .main), forCellWithReuseIdentifier: "\(ArticleCell.self)")
                
        let dataSource = UICollectionViewDiffableDataSource<HeadlinesSection, HeadlinesContainer>(collectionView: collectionView) { collectionView, indexPath, container in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ArticleCell.self)", for: indexPath) as? ArticleCell
            
            guard let category = self.viewModel.headlines.first(where: { $0.name == self.section }) else {
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
        guard
            let dataSource = context.coordinator.dataSource,
            viewModel.canReloadData else {
                return
        }
        
        self.populate(dataSource: dataSource)
    }
    
    func makeCoordinator() -> MainCoordinator {
        MainCoordinator()
    }
        
    func populate(dataSource: UICollectionViewDiffableDataSource<HeadlinesSection, HeadlinesContainer>) {
        var snapshot = NSDiffableDataSourceSnapshot<HeadlinesSection, HeadlinesContainer>()
        
        guard let category = self.viewModel.headlines.first(where: { $0.name == self.section }) else {
            return
        }
        
        let containers = category.articles.map(HeadlinesContainer.init)
        
        snapshot.appendSections([category.name])

        snapshot.appendItems(containers)

        dataSource.apply(snapshot)
        
        viewModel.canReloadData = false
    }
    
}

enum HeadlinesSection: String, Codable, CaseIterable {
    case sports
    case technology
    case business
    case general
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

