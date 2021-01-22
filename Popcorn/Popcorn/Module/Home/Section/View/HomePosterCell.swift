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
    @IBOutlet private weak var voteLb: UILabel!
    
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
        }
    }
    
    var posterHeroId: String? {
        didSet {
            posterIv.hero.id = posterHeroId
        }
    }
    
    var voteAverage: Double? {
        didSet {
            if let voteAverage = voteAverage {
                voteLb.text = "\(voteAverage)"
            } else {
                voteLb.text = "-"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        voteView.applyBlur()
        voteView.roundCorners([.topLeft, .bottomRight], radius: 10)
        posterIv.applyShadow()
        
        isSkeletonable = true
    }
}
