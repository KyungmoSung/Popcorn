//
//  _HomeViewController.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/04.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class _HomeViewController: _BaseViewController {
    var viewModel: HomeViewModel!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var moviesBtn: UIButton!
    @IBOutlet weak var showsBtn: UIButton!
    
    convenience init(viewModel: HomeViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let tapContentsType = Observable.merge(moviesBtn.rx.tap.map { ContentsType.movies },
                                               showsBtn.rx.tap.map { ContentsType.tvShows })
        
        let selectedSection = PublishRelay<Int>()
        
        let input = HomeViewModel.Input(ready: rx.viewWillAppear.asObservable(),
                                        localizeChanged: localizeChanged.asObservable(),
                                        contentsTypeSelection: tapContentsType,
                                        headerSelection: selectedSection.asObservable(),
                                        selection: collectionView.rx.itemSelected.asObservable())
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<HomeViewModel.HomeSectionItem> { dataSource, collectionView, indexPath, viewModel in
            let cell = collectionView.dequeueReusableCell(with: HomePosterCell.self, for: indexPath)
            cell.bind(viewModel)
            
            return cell
        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            let headerView = collectionView.dequeueReusableView(with: _SectionHeaderView.self, for: indexPath)
            let section = dataSource[indexPath.section].section
            let viewModel = SectionHeaderViewModel(with: section, index: indexPath.section)

            headerView.bind(viewModel)
            headerView.selection?
                .bind(to: selectedSection)
                .disposed(by: headerView.disposeBag)
            
            return headerView
        }
        
        let output = viewModel.transform(input: input)
        
        output.sectionItems
            .asDriverOnErrorJustComplete()
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.selectedContent
            .asDriverOnErrorJustComplete()
            .drive()
            .disposed(by: disposeBag)
            
        output.selectedSection
            .asDriverOnErrorJustComplete()
            .drive()
            .disposed(by: disposeBag)
    }
        
    private func setupUI() {
        collectionView.collectionViewLayout = createCompositionalLayout()
        
        collectionView.register(cellType: HomePosterCell.self)
        collectionView.register(reusableViewType: _SectionHeaderView.self)
    }
}

extension _HomeViewController {
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // 그룹
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(160),
                                               heightDimension: .absolute(240+30))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // 섹션
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 15
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 40, trailing: 20)

        // 헤더
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(100))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
