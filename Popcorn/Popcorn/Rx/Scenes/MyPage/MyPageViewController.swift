//
//  MyPageViewController.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/11/09.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MyPageViewController: _BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: MyPageViewModel!
    
    convenience init(viewModel: MyPageViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        self.title = "myPage".localized
        collectionView.register(cellType: MyPageMenuCell.self)
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    private func bindViewModel() {
        let input = MyPageViewModel.Input(ready: rx.viewWillAppear.take(1),
                                          menuSelection: collectionView.rx.itemSelected
                                            .asObservable())
        let output = viewModel.transform(input: input)
        
        output.sectionItems
            .asDriverOnErrorJustComplete()
            .drive(collectionView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
        
        output.selectedMenu
            .asDriverOnErrorJustComplete()
            .drive()
            .disposed(by: disposeBag)
    }
}

extension MyPageViewController {
    typealias DataSource = RxCollectionViewSectionedAnimatedDataSource<MyPageViewModel.Section>

    private func dataSource() -> DataSource {
        return DataSource { dataSource, collectionView, indexPath, viewModel in
            let cell = collectionView.dequeueReusableCell(with: MyPageMenuCell.self, for: indexPath)
            cell.bind(viewModel)
            
            return cell
        }
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout {   sectionIndex, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(50))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 40, trailing: 20)
            
            return section
        }
    }
}
