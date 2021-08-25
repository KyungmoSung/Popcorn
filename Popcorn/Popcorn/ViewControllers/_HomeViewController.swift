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

class _HomeViewController: UIViewController {
    private var disposeBag = DisposeBag()

    var viewModel: HomeViewModel!

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupUI()
    }
    
    private func bindViewModel() {
        let ready = rx.viewWillAppear
        let selectedIndex = collectionView.rx.itemSelected
        let selectedSection = PublishRelay<Int>()
        
        let input = HomeViewModel.Input(ready: ready.asDriver(),
                                        selectedIndex: selectedIndex.asDriver(),
                                        selectedSection: selectedSection.asDriver(onErrorJustReturn: 0))
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<HomeViewModel.HomeSection> { dataSource, collectionView, indexPath, viewModel in
            guard let cell = collectionView.dequeueReusableCell(with: HomePosterCell.self, for: indexPath) else {
                return UICollectionViewCell()
            }
        
            cell.title = viewModel.title
            cell.posterImgPath = viewModel.posterImgPath
            cell.voteAverage = viewModel.voteAverage
            
            return cell
        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            guard let headerView = collectionView.dequeueReusableView(with: _SectionHeaderView.self, for: indexPath) else {
                return UICollectionReusableView()
            }
            let section = dataSource[indexPath.section]
            
            headerView.title = section.sectionType.title
            headerView.detailBtn.rx.tap
                .map{ indexPath.section }
                .bind(to: selectedSection)
                .disposed(by: self.disposeBag)
            
            return headerView
        }
        
        let output = viewModel.transform(input: input)
        
        output.contents
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.selectedContentID
            .drive(onNext: { id in
                print(id)
            })
            .disposed(by: disposeBag)
            
        output.selectedSection
            .drive(onNext: { section in
                print(section)
            })
            .disposed(by: disposeBag)
    }
        
    private func setupUI() {
        collectionView.collectionViewLayout = createCompositionalLayout()
        
        collectionView.register(cellType: HomePosterCell.self)
        collectionView.register(reusableViewType: _SectionHeaderView.self)
    }

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
