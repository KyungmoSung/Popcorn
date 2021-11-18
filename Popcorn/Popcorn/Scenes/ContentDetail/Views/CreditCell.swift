//
//  CreditCell.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/13.
//

import UIKit
import Kingfisher

class CreditCell: UICollectionViewCell {
    @IBOutlet private weak var nameLb: UILabel!
    @IBOutlet private weak var jobLb: UILabel!
    @IBOutlet private weak var profileIv: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileIv.superview?.applyShadow()
    }
    
    func bind(_ viewModel: CreditItemViewModel)  {
        nameLb.text = viewModel.name
        jobLb.text = viewModel.job
        profileIv.kf.setImage(with: viewModel.profileURL, placeholder: UIImage(named: "icAvatar"), options: [.transition(.fade(1))])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileIv.kf.cancelDownloadTask()
        profileIv.image = nil
    }
}
