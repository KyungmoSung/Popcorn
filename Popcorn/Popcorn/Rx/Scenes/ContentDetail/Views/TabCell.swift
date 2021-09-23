//
//  TabCell.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/11.
//

import UIKit

class TabCell: UICollectionViewCell {
    @IBOutlet private weak var titleLb: UILabel!
    @IBOutlet private weak var selectedBottomLine: UIView!
    @IBOutlet weak var selectedBottomLineWidth: NSLayoutConstraint!
    
    var title: String? {
        didSet {
            titleLb.text = title
        }
    }
    
    
    func bind(_ viewModel: TabItemViewModel)  {
        titleLb.text = viewModel.title
        
        selectedBottomLine.isHidden = !viewModel.isSelected
        titleLb.font = .NanumSquare(size: 14, family: viewModel.isSelected ? .ExtraBold : .Bold)
        //                systemFont(ofSize: 15, weight: isSelected ? .semibold : .medium)
        titleLb.textColor = viewModel.isSelected ? .label : .secondaryLabel
        
        selectedBottomLineWidth.constant = viewModel.isSelected ? 0 : frame.width
        layoutIfNeeded()
        
        selectedBottomLineWidth.constant = viewModel.isSelected ? frame.width : 0
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}
