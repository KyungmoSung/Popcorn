//
//  ContentListViewController.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/10.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import NSObject_Rx

class ContentListViewController: _BaseViewController {
    var viewModel: BaseViewModel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    convenience init(viewModel: BaseViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
    }

    private func bindViewModel(){
        let ready = rx.viewWillAppear.take(1).asObservable()
        let scrollToBottom = collectionView.rx.contentOffset
            .flatMap { offset -> Observable<Void> in
                let scrollViewHeight = self.collectionView.bounds.size.height
                let contentHeight = self.collectionView.contentSize.height
                
                if contentHeight > 0 && offset.y + scrollViewHeight > contentHeight {
                    return Observable.just(())
                } else {
                    return Observable.empty()
                }
            }.throttle(.seconds(1), scheduler: MainScheduler.instance)
        
        switch viewModel {
        case let viewModel as ContentListViewModel:
            let input = ContentListViewModel.Input(ready: ready, scrollToBottom: scrollToBottom)
            let output = viewModel.transform(input: input)
            
            output.title
                .asDriverOnErrorJustComplete()
                .drive(rx.title)
                .disposed(by: disposeBag)
            
            output.sectionItems
                .asDriverOnErrorJustComplete()
                .drive(collectionView.rx.items(dataSource: contentsDataSource()))
                .disposed(by: disposeBag)
        case let viewModel as CreditListViewModel:
            let input = CreditListViewModel.Input(ready: ready)
            let output = viewModel.transform(input: input)
            
            output.title
                .asDriverOnErrorJustComplete()
                .drive(rx.title)
                .disposed(by: disposeBag)
            
            output.sectionItems
                .asDriverOnErrorJustComplete()
                .drive(collectionView.rx.items(dataSource: creditsDataSource()))
                .disposed(by: disposeBag)
        default:
            break
        }
    }
    
    private func setupUI() {
        collectionView.register(cellType: PosterCell.self)
        collectionView.register(cellType: _CreditCell.self)
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
}

extension ContentListViewController {
    typealias ContentsDataSource = RxCollectionViewSectionedAnimatedDataSource<ContentListViewModel.ListSectionItem>
    typealias CreditsDataSource = RxCollectionViewSectionedAnimatedDataSource<CreditListViewModel.ListSectionItem>
    
    private func contentsDataSource() -> ContentsDataSource {
        return ContentsDataSource { dataSource, collectionView, indexPath, viewModel in
            let cell = collectionView.dequeueReusableCell(with: PosterCell.self, for: indexPath)
            cell.bind(viewModel)
            
            return cell
        }
    }
    
    private func creditsDataSource() -> CreditsDataSource {
        return CreditsDataSource { dataSource, collectionView, indexPath, viewModel in
            let cell = collectionView.dequeueReusableCell(with: _CreditCell.self, for: indexPath)
            cell.bind(viewModel)
            
            return cell
        }
    }

    private func createCompositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout {   sectionIndex, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .estimated(100))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .estimated(100))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
            group.interItemSpacing = .fixed(15)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 30
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 40, trailing: 20)
            
            return section
        }
    }
}
