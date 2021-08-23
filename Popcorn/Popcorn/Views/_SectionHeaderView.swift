//
//  SectionHeaderView.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import UIKit

class _SectionHeaderView: UICollectionReusableView {
    @IBOutlet private weak var titleLb: UILabel!
    @IBOutlet weak var detailBtn: UIButton!
    
    var title: String? {
        get {
            return titleLb.text
        }
        set {
            titleLb.text = newValue
        }
    }
    
    @IBAction func tapDetailBtn(_ sender: Any) {
    }
}
