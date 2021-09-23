//
//  ReportCell.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/23.
//

import UIKit

class ReportCell: UICollectionViewCell {
    @IBOutlet private weak var titleLb: UILabel!
    @IBOutlet private weak var contentLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.applyShadow()
    }
    
    func bind(_ viewModel: ReportItemViewModel)  {
        titleLb.text = viewModel.title
        contentLb.text = viewModel.content
    }
}
