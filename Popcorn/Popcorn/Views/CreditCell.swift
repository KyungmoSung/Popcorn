//
//  CreditCell.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/13.
//

import UIKit

class CreditCell: UICollectionViewCell {
    @IBOutlet private weak var profileIv: UIImageView!
    @IBOutlet private weak var nameLb: UILabel!
    @IBOutlet private weak var descLb: UILabel!
    
    var profilePath: String? {
        didSet {
            if let path = profilePath, let url = URL(string: AppConstants.Domain.tmdbImage + path) {
                Nuke.loadImage(with: url, options: ImageLoadingOptions.fadeIn, into: profileIv)
            } else {
                profileIv.image = UIImage(named: "icAvatar")
            }
        }
    }
    
    var profileHeroId: String? {
        didSet {
            profileIv.hero.id = profileHeroId
        }
    }
    
    var name: String? {
        didSet {
            nameLb.text = name
        }
    }
    
    var desc: String? {
        didSet {
            descLb.text = desc
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileIv.superview?.applyShadow()
    }
}
