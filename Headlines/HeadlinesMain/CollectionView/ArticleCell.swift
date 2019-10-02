//
//  ArticleCell.swift
//  Headlines
//
//  Created by Jullianm on 25/08/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import UIKit
import SDWebImage

class ArticleCell: UICollectionViewCell {

    @IBOutlet weak var articleLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView! {
        didSet {
            articleImageView.image = UIImage(named: "news.jpg")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        backgroundColor = .white
        
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.layer.cornerRadius = 10.0
        articleImageView.layer.masksToBounds = true
    }
    
    func configure(article: Article) {
        articleLabel.text = article.title
        let encoded = article.urlToImage?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
        articleImageView.sd_setImage(with: URL(string: encoded), placeholderImage: UIImage(named: "news.jpg"))
    }
}
