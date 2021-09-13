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
        let input = ContentListViewModel.Input(ready: rx.viewWillAppear.take(1).asObservable())
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<ContentListViewModel.ListSectionItem> { dataSource, collectionView, indexPath, viewModel in
            let cell = collectionView.dequeueReusableCell(with: HomePosterCell.self, for: indexPath)
            cell.bind(viewModel)
            
            return cell
        }
        
        let output = viewModel.transform(input: input)
        
        output.title
            .asDriverOnErrorJustComplete()
            .drive(rx.title)
            .disposed(by: disposeBag)
        
        output.sectionItems
            .asDriverOnErrorJustComplete()
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
    
    private func setupUI() {
        collectionView.register(cellType: HomePosterCell.self)
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
}

extension ContentListViewController {
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
