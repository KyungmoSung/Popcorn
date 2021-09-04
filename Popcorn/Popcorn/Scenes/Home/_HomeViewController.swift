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
        let localizeChanged = Observable.merge(languageChanged.asObservable(),
                                               regionChanged.asObservable())
        
        let tapContentsType = Observable.merge(moviesBtn.rx.tap.map { ContentsType.movies },
                                               showsBtn.rx.tap.map { ContentsType.tvShows })
        
        let selectedSection = PublishRelay<Int>()
        
        let input = HomeViewModel.Input(ready: rx.viewWillAppear.asDriver(),
                                        localizeChanged: localizeChanged.asDriver(onErrorJustReturn: ()),
                                        contentsTypeSelection: tapContentsType.asDriver(onErrorJustReturn: .movies),
                                        headerSelection: selectedSection.asDriver(onErrorJustReturn: 0),
                                        selection: collectionView.rx.itemSelected.asDriver())
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<HomeViewModel.HomeSectionItem> { dataSource, collectionView, indexPath, viewModel in
            guard let cell = collectionView.dequeueReusableCell(with: HomePosterCell.self, for: indexPath) else {
                return UICollectionViewCell()
            }
            
            cell.bind(viewModel)
            
            return cell
        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            guard let headerView = collectionView.dequeueReusableView(with: _SectionHeaderView.self, for: indexPath) else {
                return UICollectionReusableView()
            }
            let section = dataSource[indexPath.section]
            
            headerView.title = section.section.title
            headerView.detailBtn.tag = indexPath.section
            headerView.detailBtn.rx.tap
                .map{ headerView.detailBtn.tag }
                .bind(to: selectedSection)
                .disposed(by: self.disposeBag)
            
            return headerView
        }
        
        let output = viewModel.transform(input: input)
        
        output.sectionItems
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.selectedContent
            .drive()
            .disposed(by: disposeBag)
            
        output.selectedSection
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
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 2)
        
        // 섹션
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        // 헤더
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(55))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                        elementKind: UICollectionView.elementKindSectionHeader,
                                                                        alignment: .top)
        sectionHeader.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
