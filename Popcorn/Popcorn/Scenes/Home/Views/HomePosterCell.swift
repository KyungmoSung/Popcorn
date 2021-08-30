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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLb.numberOfLines = 1 // 스켈레톤뷰 적용시 셀 밖으로 벗어나는 현상 방지
        
        voteView.applyBlur()
        voteView.roundCorners([.topLeft, .bottomRight], radius: 10)
        
        posterIv.superview?.applyShadow()
    }
    
    func bind(_ viewModel: PosterItemViewModel) {
        titleLb.text = viewModel.title
        titleLb.numberOfLines = 2 // 스켈레톤뷰 적용시 셀 밖으로 벗어나는 현상 방지
        
        if let path = viewModel.posterImgPath,
           let url = URL(string: AppConstants.Domain.tmdbImage + path) {
            Nuke.loadImage(with: url, options: ImageLoadingOptions.fadeIn, into: posterIv)
        }
        
        posterIv.hero.id = viewModel.posterHeroId

        if let voteAverage = viewModel.voteAverage {
            voteLb.text = "\(voteAverage)"
        } else {
            voteLb.text = "-"
        }
    }
}
