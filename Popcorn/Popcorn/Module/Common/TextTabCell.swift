//
//  TextTabCell.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/11.
//

import UIKit

class TextTabCell: UICollectionViewCell {
    @IBOutlet private weak var titleLb: UILabel!
    @IBOutlet private weak var selectedBottomLine: UIView!
    @IBOutlet weak var selectedBottomLineWidth: NSLayoutConstraint!
    
    override var isSelected: Bool {
        didSet {
            selectedBottomLine.isHidden = !isSelected
            titleLb.font = .systemFont(ofSize: 15, weight: isSelected ? .semibold : .medium)
            titleLb.textColor = isSelected ? .label : .secondaryLabel
            
            selectedBottomLineWidth.constant = isSelected ? 0 : frame.width
            layoutIfNeeded()
                
            selectedBottomLineWidth.constant = isSelected ? frame.width : 0
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }
    
    var title: String? {
        didSet {
            titleLb.text = title
        }
    }
}
