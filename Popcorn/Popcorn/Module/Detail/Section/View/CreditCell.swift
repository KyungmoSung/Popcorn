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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.applyShadow()
    }
    
    var profilePath: String? {
        didSet {
            guard let path = profilePath, let url = URL(string: AppConstants.Domain.tmdbImage + path) else {
                return
            }
            Nuke.loadImage(with: url, options: ImageLoadingOptions.fadeIn, into: profileIv)
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
}
