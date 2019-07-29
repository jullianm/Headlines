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
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "BreakingNewsCell")
                
        let dataSource = UICollectionViewDiffableDataSource<BreakingNewsSection, BreakingNewsContainer>(collectionView: collectionView) { collectionView, indexPath, container in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BreakingNewsCell", for: indexPath)
            cell.backgroundColor = .black
            cell.layer.cornerRadius = 5.0
            cell.layer.masksToBounds = true
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
        
        minimumLineSpacing = 10
        scrollDirection = .horizontal
        itemSize = .init(width: collectionView.frame.size.width - 40, height: collectionView.frame.size.height)
        sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
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
         
         return CGPoint(x: newHorizontalOffset-65, y: proposedContentOffset.y)
     }
    
}

