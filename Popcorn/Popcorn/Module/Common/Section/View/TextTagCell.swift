//
//  TextTagCell.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/12/15.
//

import UIKit

class TextTagCell: UICollectionViewCell {
    @IBOutlet private weak var titleLb: UILabel!
    
    var title: String? {
        didSet {
            titleLb.text = title
        }
    }
}
