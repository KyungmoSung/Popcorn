//
//  HomeBackdropCell.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/11/03.
//

import UIKit

class HomeBackdropCell: UICollectionViewCell {
    @IBOutlet private weak var backdropIv: UIImageView!
    @IBOutlet private weak var titleLb: UILabel!
    @IBOutlet private weak var genreLb: UILabel!
    
    var backdropImgPath: String? {
        didSet {
            guard let path = backdropImgPath, let url = URL(string: AppConstants.Domain.tmdbImage + path) else {
                return
            }
            Nuke.loadImage(with: url, options: ImageLoadingOptions.fadeIn, into: backdropIv)
        }
    }
    
    var title: String? {
        didSet {
            titleLb.text = title
        }
    }
    
    var genre: String? {
        didSet {
            genreLb.text = genre
        }
    }
    
    var index: Int? {
        didSet {
            if index == 0 {
                medal = "🥇"
            } else if index == 1 {
                medal = "🥈"
            } else if index == 2 {
                medal = "🥉"
            }
        }
    }
    
    var medal: String? {
        didSet {
            if let medal = medal, let title = title {
                titleLb.text = "\(medal) \(title)"
            }
        }
    }
}
