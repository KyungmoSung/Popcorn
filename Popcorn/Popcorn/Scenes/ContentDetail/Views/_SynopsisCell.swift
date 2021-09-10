//
//  _SynopsisCell.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/09.
//

import UIKit

class _SynopsisCell: UICollectionViewCell {
    @IBOutlet weak var synopsisLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(_ viewModel: SynopsisViewModel){
        let font =  UIFont.NanumSquare(size: 14, family: viewModel.isTagline ? .ExtraBold : .Regular)
        let synopsis = viewModel.synopsis.replacingOccurrences(of: ". ", with: ".\n")
        synopsisLb.attributedText = synopsis.attributedString(font: font)
    }
}
