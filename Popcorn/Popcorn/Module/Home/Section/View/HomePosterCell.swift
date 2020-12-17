//
//  HomePosterCell.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import UIKit

class HomePosterCell: UICollectionViewCell {
    @IBOutlet private weak var titleLb: UILabel!
    @IBOutlet private weak var posterIv: UIImageView!
    @IBOutlet private weak var voteView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        voteView.applyBlur()
    }

    var title: String? {
        didSet {
            titleLb.text = title
        }
    }
    
    var posterImgPath: String? {
        didSet {
            guard let path = posterImgPath, let url = URL(string: AppConstants.Domain.tmdbImage + path) else {
                return
            }
            Nuke.loadImage(with: url, options: ImageLoadingOptions.fadeIn, into: posterIv)
            posterIv.hero.id = path
            posterIv.heroModifiers = [.spring(stiffness: 300, damping: 25)]
        }
    }
    
    override func layoutSubviews() {
        voteView.roundCorners([.bottomRight], radius: 10)
    }
}
