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
            titleLb.font = .NanumSquare(size: 22, family: isSelected ? .ExtraBold : .Bold)
//                systemFont(ofSize: 15, weight: isSelected ? .semibold : .medium)
            titleLb.textColor = isSelected ? .label : .secondaryLabel
        }
    }
    
    var title: String? {
        didSet {
            titleLb.text = title
        }
    }
}
