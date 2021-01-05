//
//  InfoCardCell.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/23.
//

import UIKit

class InfoCardCell: UICollectionViewCell {
    @IBOutlet private weak var titleLb: UILabel!
    @IBOutlet private weak var descLb: UILabel!
    
    var title: String? {
        didSet {
            titleLb.text = title
        }
    }
    
    var desc: String? {
        didSet {
            descLb.text = desc
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.applyShadow()
    }
}
