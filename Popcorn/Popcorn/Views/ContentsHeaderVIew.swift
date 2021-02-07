//
//  ContentsHeaderVIew.swift
//  Popcorn
//
//  Created by Kyungmo on 2021/01/07.
//

import UIKit

class ContentsHeaderVIew: UICollectionViewCell {
    @IBOutlet private weak var titleLb: UILabel!
    @IBOutlet private weak var subTitleLb: UILabel!
    @IBOutlet private weak var voteAverageLb: UILabel!
    @IBOutlet private weak var starIv: UIImageView!
    @IBOutlet weak var genreCollectionView: UICollectionView!
    
    var title: String? {
        didSet {
            titleLb.text = title
        }
    }
    
    var originalTitle: String? {
        didSet {
            setSubTitle()
        }
    }
    
    var year: String? {
        didSet {
            setSubTitle()
        }
    }
    
    var voteAverage: Double? = 0 {
        didSet {
            if let voteAverage = voteAverage, voteAverage > 0 {
                voteAverageLb.text = "\(voteAverage)"
            } else {
                voteAverageLb.text = "-"
            }
        }
    }
    
    func setSubTitle() {
        if let year = year, let originalTitle = originalTitle {
            subTitleLb.text = year + " · " + originalTitle
        } else if let year = year {
            subTitleLb.text = year
        } else if let originalTitle = originalTitle {
            subTitleLb.text = originalTitle
        }
    }
}

