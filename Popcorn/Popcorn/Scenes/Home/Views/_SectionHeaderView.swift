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
    
    func bind(_ viewModel: SectionHeaderViewModel) {
        titleLb.text = viewModel.section.title
    }
    
    @IBAction func tapDetailBtn(_ sender: Any) {
    }
}
