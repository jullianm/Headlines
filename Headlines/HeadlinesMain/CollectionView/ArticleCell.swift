//
//  ArticleCell.swift
//  Headlines
//
//  Created by Jullianm on 25/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import UIKit

class ArticleCell: UICollectionViewCell {

    @IBOutlet weak var articleLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        backgroundColor = .white
        layer.cornerRadius = 10.0
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 2
        layer.masksToBounds = true
        
        articleImageView.contentMode = .scaleToFill
    }
    
    func configure(article: Article) {
        articleLabel.text = article.title
        
        guard let urlString = article.urlToImage else {
            articleImageView.image = UIImage(named: "news")
            return
        }
        
        articleImageView.downloaded(from: urlString)
        
    }
    

}
