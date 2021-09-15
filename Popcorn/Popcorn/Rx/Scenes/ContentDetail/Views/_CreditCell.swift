//
//  _CreditCell.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/13.
//

import UIKit
import Kingfisher

class _CreditCell: UICollectionViewCell {
    @IBOutlet private weak var nameLb: UILabel!
    @IBOutlet private weak var jobLb: UILabel!
    @IBOutlet private weak var profileIv: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileIv.superview?.applyShadow()
    }
    
    func bind(_ viewModel: CreditCellViewModel)  {
        nameLb.text = viewModel.name
        jobLb.text = viewModel.job
        profileIv.kf.setImage(with: viewModel.profileURL, placeholder: UIImage(named: "icAvatar"), options: [.transition(.fade(1))])
    }
}
