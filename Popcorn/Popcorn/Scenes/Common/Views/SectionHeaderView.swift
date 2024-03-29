//
//  SectionHeaderView.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import UIKit
import RxSwift
import RxCocoa

class SectionHeaderView: UICollectionReusableView {
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var topSpacing: NSLayoutConstraint!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet private weak var titleLb: UILabel!
    @IBOutlet weak var detailBtn: UIButton!
    
    var selection: Observable<Int>?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func bind(_ viewModel: SectionHeaderViewModel) {
        topSpacing.constant = viewModel.index == 0 ? 10 : 0
        titleLb.text = viewModel.section.title
        
        selection = detailBtn.rx.tap
            .map{ viewModel.index }
            .asObservable()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLb.text = nil
        disposeBag = DisposeBag()
    }
}
