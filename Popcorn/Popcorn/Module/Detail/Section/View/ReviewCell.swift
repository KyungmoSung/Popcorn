//
//  ReviewCell.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/27.
//

import UIKit

class ReviewCell: UICollectionViewCell {
    @IBOutlet private weak var nameLb: UILabel!
    @IBOutlet private weak var dateLb: UILabel!
    @IBOutlet private weak var contentsLb: UILabel!
    @IBOutlet private weak var avatarIv: UIImageView!
    @IBOutlet private weak var ratingStackView: UIStackView!
    @IBOutlet private var starIvs: [UIImageView]!
    
    var avatarPath: String? {
        didSet {
            if let path = avatarPath {
                var fullPath = path.contains("http") ? path : AppConstants.Domain.tmdbImage + path
                
                if fullPath.starts(with: "/") {
                    fullPath = fullPath.replacingCharacters(in: ...fullPath.startIndex, with: "")
                }
                print("avatar_path:",fullPath)
                if let url = URL(string: fullPath) {
                    Nuke.loadImage(with: url, options: ImageLoadingOptions.fadeIn, into: avatarIv)
                }
            } else {
                avatarIv.image = UIImage(named: "icAvatar")
            }
        }
    }
    
    var name: String? {
        didSet {
            nameLb.text = name
        }
    }
    
    var date: String? {
        didSet {
            dateLb.text = date
        }
    }
    
    var contents: String? {
        didSet {
            contentsLb.attributedText = contents?.attributedString(font: UIFont.NanumSquare(size: 14, family: .Regular))
        }
    }
    
    var rate: Int? {
        didSet {
            guard let rate = rate else {
                ratingStackView.isHidden = true
                return
            }
            
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
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.applyShadow()
    }
}
