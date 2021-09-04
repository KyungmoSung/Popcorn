//
//  TitleCell.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/02.
//

import UIKit

class TitleCell: UICollectionViewCell {
    @IBOutlet private weak var titleLb: UILabel!
    @IBOutlet private weak var subTitleLb: UILabel!
    @IBOutlet private weak var voteAverageLb: UILabel!
    @IBOutlet private weak var starIv: UIImageView!
    @IBOutlet weak var genreCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bind(_ viewModel: TitleCellViewModel)  {
        titleLb.text = viewModel.title
        subTitleLb.text = viewModel.subTitle
        voteAverageLb.text = viewModel.voteAverageText
    }
}
