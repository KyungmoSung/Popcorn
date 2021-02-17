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
            titleLb.numberOfLines = 2 // 스켈레톤뷰 적용시 셀 밖으로 벗어나는 현상 방지
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
    
    var posterImage: UIImage? {
        return posterIv.image
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
        
        titleLb.numberOfLines = 1 // 스켈레톤뷰 적용시 셀 밖으로 벗어나는 현상 방지
        
        voteView.applyBlur()
        voteView.roundCorners([.topLeft, .bottomRight], radius: 10)
        
        posterIv.superview?.applyShadow()
    }
}
