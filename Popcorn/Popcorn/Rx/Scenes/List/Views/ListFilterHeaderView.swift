//
//  ListFilterHeaderView.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/11/10.
//

import UIKit
import RxSwift

class ListFilterHeaderView: UICollectionReusableView {
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var sortBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
