//
//  SegmentedControlHeaderView.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/11/10.
//

import UIKit
import RxSwift

class SegmentedControlHeaderView: UICollectionReusableView {
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
