//
//  EconomicsCollectionView.swift
//  Headlight
//
//  Created by Jullianm on 27/07/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import UIKit
import SwiftUI

struct EconomicsCollectionView: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<EconomicsCollectionView>) -> UICollectionView {

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: CollectionViewFlowLayout()
        )
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "EconomicsCell")
                
        let dataSource = UICollectionViewDiffableDataSource<EconomicsSection, EconomicsContainer>(collectionView: collectionView) { collectionView, indexPath, container in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EconomicsCell", for: indexPath)
            cell.backgroundColor = .black
            cell.layer.cornerRadius = 10.0
            cell.layer.masksToBounds = true
            return cell
            
        }
        
        populate(dataSource: dataSource)
        context.coordinator.dataSource = dataSource
        
        return collectionView
    }
    
    func updateUIView(_ uiView: UICollectionView, context: UIViewRepresentableContext<EconomicsCollectionView>) {
        //let dataSource = context.coordinator.dataSource
    }
    
    func makeCoordinator() -> EconomicsCoordinator {
        EconomicsCoordinator()
    }
    
    func populate(dataSource: UICollectionViewDiffableDataSource<EconomicsSection, EconomicsContainer>) {
        
        let snapshot = NSDiffableDataSourceSnapshot<EconomicsSection, EconomicsContainer>()
        
        snapshot.appendSections([.economics])

        snapshot.appendItems(
            [
                EconomicsContainer(),
                EconomicsContainer(),
                EconomicsContainer(),
                EconomicsContainer(),
                EconomicsContainer(),
                EconomicsContainer(),
                EconomicsContainer(),
                EconomicsContainer()
            ]
        )

        dataSource.apply(snapshot)
    }
    
}

enum EconomicsSection {
    case economics
}

class EconomicsContainer: Hashable {
    let id = UUID()

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: EconomicsContainer, rhs: EconomicsContainer) -> Bool {
        return lhs.id == rhs.id
    }
}
