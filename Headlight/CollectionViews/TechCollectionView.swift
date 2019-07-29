//
//  TechCollectionView.swift
//  Headlight
//
//  Created by Jullianm on 27/07/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import UIKit
import SwiftUI

struct TechCollectionView: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<TechCollectionView>) -> UICollectionView {

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: CollectionViewFlowLayout()
        )
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "TechCell")
                
        let dataSource = UICollectionViewDiffableDataSource<TechSection, TechContainer>(collectionView: collectionView) { collectionView, indexPath, container in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TechCell", for: indexPath)
            cell.backgroundColor = .black
             cell.layer.cornerRadius = 5.0
             cell.layer.masksToBounds = true
            return cell
            
        }
        
        populate(dataSource: dataSource)
        context.coordinator.dataSource = dataSource
        
        return collectionView
    }
    
    func updateUIView(_ uiView: UICollectionView, context: UIViewRepresentableContext<TechCollectionView>) {
        //let dataSource = context.coordinator.dataSource
    }
    
    func makeCoordinator() -> TechCoordinator {
        TechCoordinator()
    }
    
    func populate(dataSource: UICollectionViewDiffableDataSource<TechSection, TechContainer>) {
        
        let snapshot = NSDiffableDataSourceSnapshot<TechSection, TechContainer>()
        
        snapshot.appendSections([.tech])

        snapshot.appendItems(
            [
                TechContainer(),
                TechContainer(),
                TechContainer(),
                TechContainer(),
                TechContainer(),
                TechContainer(),
                TechContainer(),
                TechContainer(),
                TechContainer()
            ]
        )

        dataSource.apply(snapshot)
    }
    
}

enum TechSection {
    case tech
}

class TechContainer: Hashable {
    let id = UUID()

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: TechContainer, rhs: TechContainer) -> Bool {
        return lhs.id == rhs.id
    }
}

