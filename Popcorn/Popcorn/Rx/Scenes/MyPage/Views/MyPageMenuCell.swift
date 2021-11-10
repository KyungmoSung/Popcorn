//
//  MyPageMenuCell.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/11/10.
//

import UIKit

class MyPageMenuCell: UICollectionViewCell {
    @IBOutlet private weak var menuIv: UIImageView!
    @IBOutlet private weak var menuLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bind(_ viewModel: MenuItemViewModel) {
        menuIv.image = viewModel.image
        menuLb.text = viewModel.title
    }
}
