//
//  MediaImageCell.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/13.
//

import UIKit

class MediaImageCell: UICollectionViewCell {

    @IBOutlet private weak var backdropIv: UIImageView!
    
    var backdropImgPath: String? {
        didSet {
            guard let path = backdropImgPath, let url = URL(string: AppConstants.Domain.tmdbImage + path) else {
                return
            }
            Nuke.loadImage(with: url, options: ImageLoadingOptions.fadeIn, into: backdropIv)
        }
    }
}
