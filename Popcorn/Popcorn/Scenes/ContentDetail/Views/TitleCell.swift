//
//  TitleCell.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/02.
//

import UIKit
import RxSwift
import RxCocoa

class TitleCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    
    @IBOutlet private weak var titleLb: UILabel!
    @IBOutlet private weak var subTitleLb: UILabel!
    @IBOutlet private weak var voteAverageLb: UILabel!
    @IBOutlet private weak var starIv: UIImageView!
    @IBOutlet weak var genreCollectionView: UICollectionView!
    
    @IBOutlet weak var rateBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var watchlistBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    var actionSelection: Observable<ContentAction>?
    var shareSelection: Observable<Void>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bind(_ viewModel: TitleItemViewModel)  {
        titleLb.text = viewModel.title
        subTitleLb.text = viewModel.subTitle
        voteAverageLb.text = viewModel.voteAverageText
        
        actionSelection = Observable.merge(
            rateBtn.rx.tap.map{ ContentAction.rate },
            favoriteBtn.rx.tap.map{ ContentAction.favorite },
            watchlistBtn.rx.tap.map{ ContentAction.watchlist })
        
        shareSelection = shareBtn.rx.tap.asObservable()
        
        viewModel.state
            .asDriverOnErrorJustComplete()
            .drive { [weak self] state in
                guard let self = self else { return }
                
                self.favoriteBtn.isSelected = state.favorite ?? false
                self.watchlistBtn.isSelected = state.watchlist ?? false
            }
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLb.text = nil
        subTitleLb.text = nil
        voteAverageLb.text = nil
        
        disposeBag = DisposeBag()
    }
}
