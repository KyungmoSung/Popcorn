//
//  ImageCell.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/13.
//

import UIKit

class ImageCell: UICollectionViewCell {
    @IBOutlet private weak var backdropIv: UIImageView!
    var aspectRatio: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.applyShadow()
    }
    
    func bind(_ viewModel: ImageCellViewModel)  {
        backdropIv.kf.setImage(with: viewModel.imageURL, options: [.transition(.fade(1))])
        aspectRatio = NSLayoutConstraint(item: backdropIv!,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: backdropIv,
                                         attribute: .height,
                                         multiplier: CGFloat(viewModel.aspectRatio),
                                         constant: 0)
        backdropIv.addConstraint(aspectRatio!)
    }
    
    override func prepareForReuse() {
        if let aspectRatio = aspectRatio {
            backdropIv.removeConstraint(aspectRatio)
        }
    }
}
