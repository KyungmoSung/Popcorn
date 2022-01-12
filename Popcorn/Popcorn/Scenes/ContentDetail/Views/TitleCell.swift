//
//  TitleCell.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/02.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class TitleCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    
    @IBOutlet private weak var titleLb: UILabel!
    @IBOutlet private weak var subTitleLb: UILabel!
//    @IBOutlet private weak var voteAverageLb: UILabel!
    @IBOutlet weak var genreCollectionView: UICollectionView!
    
    @IBOutlet weak var voteAverageLb: UILabel!
    @IBOutlet weak var voteCountLb: UILabel!
    @IBOutlet weak var rateBtn: UIButton!
    @IBOutlet weak var ratingLb: UILabel!
    @IBOutlet weak var ratingTitleLb: UILabel!
    @IBOutlet weak var ratingIv: UIImageView!
    //    @IBOutlet weak var favoriteBtn: UIButton!
//    @IBOutlet weak var watchlistBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var rateIv: UIImageView!
//    @IBOutlet weak var favoriteIv: UIImageView!
//    @IBOutlet weak var watchlistIv: UIImageView!
//    var actionSelection: Observable<ContentAction>?
//    var shareSelection: Observable<Void>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
//
//    func bind(_ viewModel: TitleCellReactor)  {
//        titleLb.text = viewModel.title
//        subTitleLb.text = viewModel.subTitle
//        voteAverageLb.text = viewModel.voteAverageText
//
//        actionSelection = Observable.merge(
//            rateBtn.rx.tap.map{ ContentAction.rate },
//            favoriteBtn.rx.tap.map{ ContentAction.favorite },
//            watchlistBtn.rx.tap.map{ ContentAction.watchlist })
//
//        shareSelection = shareBtn.rx.tap.asObservable()
        
//        viewModel.state
//            .asDriverOnErrorJustComplete()
//            .drive { [weak self] state in
//                guard let self = self else { return }
//
////                rateIv.tintColor = (state.rated ?? false) ? .systemYellow : .secondaryLabel
//                self.favoriteIv.tintColor = (state.favorite ?? false) ? .systemPink : .secondaryLabel
//                self.watchlistIv.tintColor = (state.watchlist ?? false) ? .systemPurple : .secondaryLabel
//            }
//            .disposed(by: disposeBag)
//    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}

extension TitleCell: StoryboardView {
    func bind(reactor: TitleCellReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: TitleCellReactor) {
        shareBtn.rx.tap
            .map { Reactor.Action.share }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        rateBtn.rx.tap
            .map { Reactor.Action.rating}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: TitleCellReactor) {
        reactor.state
            .map { $0.title }
            .asDriverOnErrorJustComplete()
            .drive(titleLb.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.subTitle }
            .asDriverOnErrorJustComplete()
            .drive(subTitleLb.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.voteAverage }
            .asDriverOnErrorJustComplete()
            .drive(voteAverageLb.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.voteCount }
            .asDriverOnErrorJustComplete()
            .drive(voteCountLb.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.rate }
            .asDriverOnErrorJustComplete()
            .drive(ratingLb.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.rateTitle }
            .asDriverOnErrorJustComplete()
            .drive(ratingTitleLb.rx.text)
            .disposed(by: disposeBag)
        
    }
}
