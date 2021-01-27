//
//  SynopsisCell.swift
//  Popcorn
//
//  Created by Kyungmo on 2021/01/10.
//

import UIKit

class SynopsisCell: UICollectionViewCell {
    @IBOutlet private weak var synopsisLb: UILabel!
        
    var isTagline: Bool = false
    var synopsis: String? {
        didSet {
            synopsisLb.attributedText = synopsis?.attributedString(font: UIFont.NanumSquare(size: 14, family: isTagline ? .Bold : .Regular))
        }
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var newFrame = layoutAttributes.frame
        // note: don't change the width
        newFrame.size.height = ceil(size.height)
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }
}
