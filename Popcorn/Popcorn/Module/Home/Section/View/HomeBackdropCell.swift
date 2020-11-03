//
//  HomeBackdropCell.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/11/03.
//

import UIKit

class HomeBackdropCell: UICollectionViewCell {
    @IBOutlet private weak var backdropIv: UIImageView!
    
    var backdropImgPath: String? {
        didSet {
            guard let path = backdropImgPath, let url = URL(string: AppConstants.Domain.tmdbImage + path) else {
                return
            }
            let options = ImageLoadingOptions(
                transition: .fadeIn(duration: 0.3)
            )
            Nuke.loadImage(with: url, options: options, into: backdropIv)
        }
    }
}
