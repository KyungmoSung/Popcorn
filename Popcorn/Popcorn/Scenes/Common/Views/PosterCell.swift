//
//  PosterCell.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import UIKit

class PosterCell: UICollectionViewCell {
    @IBOutlet private weak var titleLb: UILabel!
    @IBOutlet private weak var posterIv: UIImageView!
    @IBOutlet private weak var voteView: UIView!
    @IBOutlet private weak var voteLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        titleLb.numberOfLines = 1 // 스켈레톤뷰 적용시 셀 밖으로 벗어나는 현상 방지
        
        voteView.applyBlur()
        voteView.roundCorners([.topLeft, .bottomRight], radius: 10)
        
        posterIv.superview?.applyShadow()
    }
    
    func bind(_ viewModel: PosterItemViewModel) {
        titleLb.text = viewModel.title
        voteLb.text = viewModel.voteAverage
        
//        titleLb.numberOfLines = 2 // 스켈레톤뷰 적용시 셀 밖으로 벗어나는 현상 방지

        posterIv.kf.setImage(with: viewModel.posterImgURL, placeholder: UIImage(named: "icAvatar"), options: [.transition(.fade(1))])
        posterIv.hero.id = viewModel.posterHeroId
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterIv.kf.cancelDownloadTask()
        posterIv.image = nil
    }
}
