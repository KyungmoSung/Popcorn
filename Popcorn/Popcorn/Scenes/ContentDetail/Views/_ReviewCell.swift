//
//  _ReviewCell.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/27.
//

import UIKit

class _ReviewCell: UICollectionViewCell {
    @IBOutlet private weak var nameLb: UILabel!
    @IBOutlet private weak var dateLb: UILabel!
    @IBOutlet private weak var contentsLb: UILabel!
    @IBOutlet private weak var avatarIv: UIImageView!
    @IBOutlet private weak var ratingStackView: UIStackView!
    @IBOutlet private var starIvs: [UIImageView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.applyShadow()
    }
    
    func bind(_ viewModel: ReviewCellViewModel) {
        avatarIv.kf.setImage(with: viewModel.profileURL,
                             placeholder: UIImage(named: "icAvatar"),
                             options: [.transition(.fade(1))])

        nameLb.text = viewModel.name
        dateLb.text = viewModel.date
        
        let font = UIFont.NanumSquare(size: 14, family: .Regular)
        contentsLb.attributedText = viewModel.contents.attributedString(font: font)
        
        if let rate = viewModel.rate {
            ratingStackView.isHidden = false
            
            starIvs.enumerated().forEach { (index, iv) in
                if index < rate / 2 {
                    iv.image = UIImage(named: "icStarFill")
                } else if index == rate / 2, rate % 2 != 0 {
                    iv.image = UIImage(named: "icStarHalf")
                } else {
                    iv.image = UIImage(named: "icStarBorder")
                }
            }

        } else {
            ratingStackView.isHidden = true

        }
    }
}
