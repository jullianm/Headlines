//
//  BreakingNewsCell.swift
//  Headlight
//
//  Created by Jullianm on 27/07/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import UIKit
import SwiftUI

struct BreakingNewsCollectionView: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<BreakingNewsCollectionView>) -> UICollectionView {

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: CollectionViewFlowLayout()
        )
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "BreakingNewCell")
                
        let dataSource = UICollectionViewDiffableDataSource<BreakingNewsSection, BreakingNewsContainer>(collectionView: collectionView) { collectionView, indexPath, container in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BreakingNewCell", for: indexPath)
            cell.backgroundColor = .red
            return cell
            
        }
        
        populate(dataSource: dataSource)
        context.coordinator.dataSource = dataSource
        
        return collectionView
    }
    
    func updateUIView(_ uiView: UICollectionView, context: UIViewRepresentableContext<BreakingNewsCollectionView>) {
        //let dataSource = context.coordinator.dataSource
    }
    
    func makeCoordinator() -> BreakingNewsCoordinator {
        BreakingNewsCoordinator()
    }
    
    func populate(dataSource: UICollectionViewDiffableDataSource<BreakingNewsSection, BreakingNewsContainer>) {
        
        let snapshot = NSDiffableDataSourceSnapshot<BreakingNewsSection, BreakingNewsContainer>()
        
        snapshot.appendSections([.breakingNews])

        snapshot.appendItems(
            [
                BreakingNewsContainer(),
                BreakingNewsContainer(),
                BreakingNewsContainer(),
                BreakingNewsContainer(),
                BreakingNewsContainer(),
                BreakingNewsContainer(),
                BreakingNewsContainer(),
                BreakingNewsContainer(),
                BreakingNewsContainer(),
                BreakingNewsContainer()
            ]
        )

        dataSource.apply(snapshot)
    }
    
}

enum BreakingNewsSection {
    case breakingNews
}

class BreakingNewsContainer: Hashable {
    let id = UUID()

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: BreakingNewsContainer, rhs: BreakingNewsContainer) -> Bool {
        return lhs.id == rhs.id
    }
}

class CollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        
        guard let collectionView = collectionView else {
            return
        }
    
        collectionView.backgroundColor = .clear
        scrollDirection = .horizontal
        collectionView.showsVerticalScrollIndicator = false
        itemSize = .init(width: collectionView.frame.width/1.2, height: collectionView.frame.height)
    }
    
     override func prepare() {
         super.prepare()
         self.minimumLineSpacing = 10
         self.scrollDirection = .horizontal
         guard let collectionView = collectionView else { return }
         self.itemSize = CGSize(width: collectionView.frame.size.width - 40, height: collectionView.frame.size.height - 10)
        self.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
     }
     override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
         // Page width used for estimating and calculating paging.
         let pageWidth = itemSize.width + minimumLineSpacing
         // Make an estimation of the current page position.
         let approximatePage = collectionView!.contentOffset.x/pageWidth
         // Determine the current page based on velocity.
         let currentPage = (velocity.x < 0.0) ? floor(approximatePage) : ceil(approximatePage)
    
         // Calculate newHorizontalOffset.
         let newHorizontalOffset = ((currentPage) * pageWidth) - collectionView!.contentInset.left
         
         return CGPoint(x: newHorizontalOffset - 65, y: proposedContentOffset.y)
     }
    
}

