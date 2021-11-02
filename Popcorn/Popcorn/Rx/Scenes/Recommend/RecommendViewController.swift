//
//  RecommendViewController.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/11/01.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class RecommendViewController: _BaseViewController {
    var viewModel: RecommendViewModel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    convenience init(viewModel: RecommendViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        collectionView.register(cellType: PosterCell.self)
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    private func bindViewModel() {
        let input = RecommendViewModel.Input(ready: rx.viewWillAppear.asObservable())
        let output = viewModel.transform(input: input)
        
        output.needSignIn
            .asDriverOnErrorJustComplete()
            .drive()
            .disposed(by: disposeBag)
        
        output.sectionItems
            .asDriverOnErrorJustComplete()
            .drive(collectionView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
    }
}

extension RecommendViewController {
    typealias DataSource = RxCollectionViewSectionedAnimatedDataSource<RecommendViewModel.RecommendSectionItem>
    
    private func dataSource() -> DataSource {
        return DataSource { dataSource, collectionView, indexPath, viewModel in
            let cell = collectionView.dequeueReusableCell(with: PosterCell.self, for: indexPath)
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
