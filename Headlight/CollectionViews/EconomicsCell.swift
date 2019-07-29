//
//  EconomicsCell.swift
//  Headlight
//
//  Created by Jullianm on 27/07/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import UIKit

final class EconomicsCell: UICollectionViewCell {
    lazy var collectionView: UICollectionView = {
               let collectionViewLayout = UICollectionViewFlowLayout()
               collectionViewLayout.scrollDirection = .horizontal
               let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
               
               collectionView.backgroundColor = .clear
               
               collectionView.dataSource = self
               collectionView.delegate = self
               collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
               
               return collectionView
           }()
           
           private let cellIdentifier = "EconomicsCell"
           
           override init(frame: CGRect) {
               super.init(frame: frame)
               install()
           }
           
           private func install() {
               addSubview(collectionView)
               setConstraints()
           }
           
           private func setConstraints() {
               collectionView.translatesAutoresizingMaskIntoConstraints = false
               collectionView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95).isActive = true
               collectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.95).isActive = true
               collectionView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
               collectionView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
           }
           
           required init?(coder: NSCoder) {
               fatalError("init(coder:) has not been implemented")
           }
}
extension EconomicsCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = .white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
