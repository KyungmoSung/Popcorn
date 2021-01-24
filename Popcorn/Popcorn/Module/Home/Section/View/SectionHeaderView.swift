//
//  SectionHeaderView.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import UIKit

protocol SectionHeaderViewDelegate: class {
    func didTapMoreBtn()
}

class SectionHeaderView: UICollectionViewCell {
    @IBOutlet private weak var titleLb: UILabel!
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
    
    @IBAction func didTapMoreBtn(_ sender: Any) {
        delegate?.didTapMoreBtn()
    }
}
