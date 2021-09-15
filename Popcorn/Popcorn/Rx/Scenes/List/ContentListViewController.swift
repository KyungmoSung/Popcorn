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
    var viewModel: ContentListViewModel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    convenience init(viewModel: ContentListViewModel) {
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
        
        
        let input = ContentListViewModel.Input(ready: ready, scrollToBottom: scrollToBottom)
        let output = viewModel.transform(input: input)
        
        output.title
            .asDriverOnErrorJustComplete()
            .drive(rx.title)
            .disposed(by: disposeBag)
        
        output.sectionItems
            .asDriverOnErrorJustComplete()
            .drive(collectionView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
        
    }
    
    private func setupUI() {
        collectionView.register(cellType: HomePosterCell.self)
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
}

extension ContentListViewController {
    typealias DataSource = RxCollectionViewSectionedAnimatedDataSource<ContentListViewModel.ListSectionItem>
    
    private func dataSource() -> DataSource {
        return DataSource { dataSource, collectionView, indexPath, viewModel in
            let cell = collectionView.dequeueReusableCell(with: HomePosterCell.self, for: indexPath)
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
