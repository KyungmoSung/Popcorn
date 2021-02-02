//
//  HeaderTitleCell.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/02/01.
//

import UIKit

class HeaderTitleCell: UICollectionViewCell {
    @IBOutlet private weak var titleLb: UILabel!
        
    override var isSelected: Bool {
        didSet {
            titleLb.font = .NanumSquare(size: 32, family: .ExtraBold)
            titleLb.textColor = isSelected ? .label : .secondaryLabel
        }
    }
    
    var title: String? {
        didSet {
            titleLb.text = title
        }
    }
}
