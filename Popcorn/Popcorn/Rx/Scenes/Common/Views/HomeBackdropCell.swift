//
//  HomeBackdropCell.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/11/03.
//

import UIKit

class HomeBackdropCell: UICollectionViewCell {
    @IBOutlet private weak var backdropIv: UIImageView!
    @IBOutlet private weak var voteView: UIView!
    @IBOutlet private weak var voteLb: UILabel!
    @IBOutlet private weak var titleLb: UILabel!
    @IBOutlet private weak var originalTitleLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        voteView.applyBlur()
        voteView.roundCorners([.topLeft, .bottomRight], radius: 10)
        
        contentView.applyShadow()
    }
    
    func bind(_ viewModel: BackdropItemViewModel) {
        titleLb.text = viewModel.title
        originalTitleLb.text = viewModel.subTitle
        voteLb.text = viewModel.voteAverage
        
        backdropIv.kf.setImage(with: viewModel.backdropImgURL, placeholder: UIImage(named: "icAvatar"), options: [.transition(.fade(1))])
        backdropIv.hero.id = viewModel.backdropHeroId
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        backdropIv.kf.cancelDownloadTask()
        backdropIv.image = nil
    }
}
