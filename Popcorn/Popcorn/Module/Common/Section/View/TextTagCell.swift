//
//  TextTagCell.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/12/15.
//

import UIKit

class TextTagCell: UICollectionViewCell {
    @IBOutlet private weak var titleLb: UILabel!
    
    var title: String? {
        didSet {
            titleLb.text = title
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.cornerRadius = self.frame.height / 2
        contentView.borderColor = .secondaryLabel
        contentView.borderWidth = 0.5
    }
}
