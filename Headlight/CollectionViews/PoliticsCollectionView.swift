//
//  PoliticsCollectionView.swift
//  Headlight
//
//  Created by Jullianm on 27/07/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import UIKit
import SwiftUI

struct PoliticsCollectionView: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<PoliticsCollectionView>) -> UICollectionView {

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: CollectionViewFlowLayout()
        )
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PoliticsCell")
                
        let dataSource = UICollectionViewDiffableDataSource<PoliticsSection, PoliticsContainer>(collectionView: collectionView) { collectionView, indexPath, container in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PoliticsCell", for: indexPath)
             cell.backgroundColor = .black
             cell.layer.cornerRadius = 5.0
             cell.layer.masksToBounds = true
            return cell
            
        }
        
        populate(dataSource: dataSource)
        context.coordinator.dataSource = dataSource
        
        return collectionView
    }
    
    func updateUIView(_ uiView: UICollectionView, context: UIViewRepresentableContext<PoliticsCollectionView>) {
        //let dataSource = context.coordinator.dataSource
    }
    
    func makeCoordinator() -> PoliticsCoordinator {
        PoliticsCoordinator()
    }
    
    func populate(dataSource: UICollectionViewDiffableDataSource<PoliticsSection, PoliticsContainer>) {
        
        let snapshot = NSDiffableDataSourceSnapshot<PoliticsSection, PoliticsContainer>()
        
        snapshot.appendSections([.politics])

        snapshot.appendItems(
            [
                PoliticsContainer(),
                PoliticsContainer(),
                PoliticsContainer(),
                PoliticsContainer(),
                PoliticsContainer(),
                PoliticsContainer(),
                PoliticsContainer(),
                PoliticsContainer(),
                PoliticsContainer()
            ]
        )

        dataSource.apply(snapshot)
    }
    
}

enum PoliticsSection {
    case politics
}

class PoliticsContainer: Hashable {
    let id = UUID()

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: PoliticsContainer, rhs: PoliticsContainer) -> Bool {
        return lhs.id == rhs.id
    }
}
