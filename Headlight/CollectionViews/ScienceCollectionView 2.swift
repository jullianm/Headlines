//
//  ScienceCollectionView.swift
//  Headlight
//
//  Created by Jullianm on 27/07/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import UIKit
import SwiftUI

struct ScienceCollectionView: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<ScienceCollectionView>) -> UICollectionView {

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: CollectionViewFlowLayout()
        )
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ScienceCell")
                
        let dataSource = UICollectionViewDiffableDataSource<ScienceSection, ScienceContainer>(collectionView: collectionView) { collectionView, indexPath, container in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScienceCell", for: indexPath)
            cell.backgroundColor = .black
            cell.layer.cornerRadius = 10.0
            cell.layer.masksToBounds = true
            return cell
            
        }
        
        populate(dataSource: dataSource)
        context.coordinator.dataSource = dataSource
        
        return collectionView
    }
    
    func updateUIView(_ uiView: UICollectionView, context: UIViewRepresentableContext<ScienceCollectionView>) {
        //let dataSource = context.coordinator.dataSource
    }
    
    func makeCoordinator() -> ScienceCoordinator {
        ScienceCoordinator()
    }
    
    func populate(dataSource: UICollectionViewDiffableDataSource<ScienceSection, ScienceContainer>) {
        
        let snapshot = NSDiffableDataSourceSnapshot<ScienceSection, ScienceContainer>()
        
        snapshot.appendSections([.science])

        snapshot.appendItems(
            [
                ScienceContainer(),
                ScienceContainer(),
                ScienceContainer(),
                ScienceContainer(),
                ScienceContainer(),
                ScienceContainer(),
                ScienceContainer(),
                ScienceContainer(),
                ScienceContainer()
            ]
        )

        dataSource.apply(snapshot)
    }
    
}

enum ScienceSection {
    case science
}

class ScienceContainer: Hashable {
    let id = UUID()

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: ScienceContainer, rhs: ScienceContainer) -> Bool {
        return lhs.id == rhs.id
    }
}
