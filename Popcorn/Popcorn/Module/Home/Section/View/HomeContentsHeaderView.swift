//
//  HomeContentsHeaderView.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import UIKit

class HomeContentsHeaderView: UICollectionViewCell {
    @IBOutlet private weak var titleLb: UILabel!
    
    var title: String? {
        get {
            return titleLb.text
        }
        set {
            titleLb.text = newValue
        }
    }

}
