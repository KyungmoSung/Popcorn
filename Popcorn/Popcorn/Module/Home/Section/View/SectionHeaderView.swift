//
//  SectionHeaderView.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import UIKit

protocol SectionHeaderViewDelegate: class {
    func didTapExpandBtn()
}

class SectionHeaderView: UICollectionViewCell {
    @IBOutlet private weak var titleLb: UILabel!
    @IBOutlet private weak var expandBtn: UIButton!
    @IBOutlet weak var tabCollectionView: UICollectionView!
    
    weak var delegate: SectionHeaderViewDelegate?
    
    var title: String? {
        get {
            return titleLb.text
        }
        set {
            titleLb.text = newValue
        }
    }
    
    var expandable: Bool = false {
        didSet {
            expandBtn.isHidden = !expandable
        }
    }
    
    @IBAction func didTapExpandBtn(_ sender: Any) {
        delegate?.didTapExpandBtn()
    }
}
