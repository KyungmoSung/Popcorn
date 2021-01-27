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
    
    var subTitle: String? {
        didSet {
            subTitleLb.text = subTitle
        }
    }
    
    var voteAverage: Double = 0 {
        didSet {
            voteAverageLb.text = voteAverage > 0 ? "\(voteAverage)" : "-"
        }
    }
}

