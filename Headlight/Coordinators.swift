//
//  Coordinator.swift
//  Headlight
//
//  Created by Jullianm on 27/07/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import SwiftUI

protocol Coordinator {
    associatedtype Section: Hashable
    associatedtype Container: Hashable
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Container>? { get set }
}

class BreakingNewsCoordinator: Coordinator {
    var dataSource: UICollectionViewDiffableDataSource<BreakingNewsSection, BreakingNewsContainer>?
}

class TechCoordinator: Coordinator {
    var dataSource: UICollectionViewDiffableDataSource<TechSection, TechContainer>?
}

class EconomicsCoordinator: Coordinator {
    var dataSource: UICollectionViewDiffableDataSource<EconomicsSection, EconomicsContainer>?
}

class PoliticsCoordinator: Coordinator {
    var dataSource: UICollectionViewDiffableDataSource<PoliticsSection, PoliticsContainer>?
}

class ScienceCoordinator: Coordinator {
    var dataSource: UICollectionViewDiffableDataSource<ScienceSection, ScienceContainer>?
}
