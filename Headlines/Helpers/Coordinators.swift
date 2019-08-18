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

class MainCoordinator: Coordinator {
    var dataSource: UICollectionViewDiffableDataSource<HeadlinesSection, HeadlinesContainer>?
}
