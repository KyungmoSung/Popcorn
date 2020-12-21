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
    
    var backdropImgPath: String? {
        didSet {
            guard let path = backdropImgPath, let url = URL(string: AppConstants.Domain.tmdbImage + path) else {
                return
            }
            Nuke.loadImage(with: url, options: ImageLoadingOptions.fadeIn, into: backdropIv)
        }
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
    
    var title: String? {
        didSet {
            titleLb.text = title
        }
    }
    
    var originalTitle: String? {
        didSet {
            if title != originalTitle {
                originalTitleLb.text = originalTitle
            } else {
                originalTitleLb.text = nil
            }
        }
    }
    
    var releaseDate: Date? {
        didSet {
            if let releaseDate = releaseDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy"
                let year = dateFormatter.string(from: releaseDate)
                
                if let text = originalTitleLb.text {
                    originalTitleLb.text = year + " · " + text
                } else {
                    originalTitleLb.text = year
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        voteView.applyBlur()
        contentView.applyShadow()
    }
    
    override func layoutSubviews() {
        voteView.roundCorners([.topLeft, .bottomRight], radius: 10)
    }
}
