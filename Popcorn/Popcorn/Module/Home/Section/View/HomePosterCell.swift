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
        
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = voteView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        voteView.addSubview(blurEffectView)
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
        }
    }
    
    override func layoutSubviews() {
        voteView.roundCorners([.bottomRight], radius: 10)
    }
}
