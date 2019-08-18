//
//  ReusableCollectionView.swift
//  Headlight
//
//  Created by Jullianm on 16/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import UIKit
import SwiftUI

class ReusableCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    
    var section: HeadlinesSection
    
    init(section: HeadlinesSection) {
        self.section = section
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

struct ReusableCollectionView: UIViewRepresentable {
    
    let section: HeadlinesSection
    let delegate: ReusableCollectionViewDelegate
    
    init(section: HeadlinesSection) {
        self.section = section
        self.delegate = ReusableCollectionViewDelegate(section: section)
    }
    
    func makeUIView(context: UIViewRepresentableContext<ReusableCollectionView>) -> UICollectionView {

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: CollectionViewFlowLayout()
        )
        
        collectionView.delegate = delegate

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
                
        let dataSource = UICollectionViewDiffableDataSource<HeadlinesSection, HeadlinesContainer>(collectionView: collectionView) { collectionView, indexPath, container in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            cell.backgroundColor = .black
            cell.layer.cornerRadius = 10.0
            cell.layer.masksToBounds = true
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
    
    func populate(dataSource: UICollectionViewDiffableDataSource<HeadlinesSection, HeadlinesContainer>) {
        
        let snapshot = NSDiffableDataSourceSnapshot<HeadlinesSection, HeadlinesContainer>()
        
        snapshot.appendSections([section])

        snapshot.appendItems(
            [
                HeadlinesContainer(),
                HeadlinesContainer(),
                HeadlinesContainer(),
                HeadlinesContainer(),
                HeadlinesContainer(),
                HeadlinesContainer()
            ]
        )

        dataSource.apply(snapshot)
    }
    
}

enum HeadlinesSection: String, CaseIterable {
    case sports
    case tech
    case economics
    case politics
    case science
    case environment
}


class HeadlinesContainer: Hashable {
    let id = UUID()

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: HeadlinesContainer, rhs: HeadlinesContainer) -> Bool {
        return lhs.id == rhs.id
    }
}


