//
//  CollectionViewFlowLayout.swift
//  Headlight
//
//  Created by Jullianm on 16/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import UIKit

class CollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {
            return
        }
        
        minimumLineSpacing = 10
        collectionView.backgroundColor = .clear
        scrollDirection = .horizontal
//        sectionInset = .init(top: 0, left: 20.0, bottom: 0, right: 0)
        itemSize = .init(width: collectionView.frame.size.width/1.2, height: collectionView.frame.size.height)
        
     }
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        // Page width used for estimating and calculating paging.
        let pageWidth = itemSize.width + minimumLineSpacing
        // Make an estimation of the current page position.
        let approximatePage = collectionView!.contentOffset.x/pageWidth
        // Determine the current page based on velocity.
        let currentPage = (velocity.x < 0.0) ? floor(approximatePage) : ceil(approximatePage)
        
        // Calculate newHorizontalOffset.
        let newHorizontalOffset = ((currentPage) * pageWidth) - 30
        
        return CGPoint(x: newHorizontalOffset, y: proposedContentOffset.y)
    }
    
}


