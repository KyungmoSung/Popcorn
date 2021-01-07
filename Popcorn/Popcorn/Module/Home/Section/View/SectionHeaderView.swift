//
//  SectionHeaderView.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import UIKit

class SectionHeaderView: UICollectionViewCell {
    @IBOutlet private weak var titleLb: UILabel!
    @IBOutlet weak var tabCollectionView: UICollectionView!
    
    var title: String? {
        get {
            return titleLb.text
        }
        set {
            titleLb.text = newValue
        }
    }
}
