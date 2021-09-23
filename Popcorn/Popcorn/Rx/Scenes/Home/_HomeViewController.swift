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
    
    let selectedSection = PublishRelay<Int>()

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
        
        
        let input = HomeViewModel.Input(ready: rx.viewWillAppear.take(1).asObservable(),
                                        localizeChanged: localizeChanged.asObservable(),
                                        contentsTypeSelection: tapContentsType,
                                        headerSelection: selectedSection.asObservable(),
                                        selection: collectionView.rx.itemSelected.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.sectionItems
            .asDriverOnErrorJustComplete()
            .map{ $0.map { $0.section } }
            .drive { [weak self] sections in
                guard let self = self else { return }
                self.collectionView.collectionViewLayout = self.createCompositionalLayout(with: sections)
            }
            .disposed(by: disposeBag)
            
        output.sectionItems
            .asDriverOnErrorJustComplete()
            .drive(collectionView.rx.items(dataSource: dataSource()))
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
        collectionView.register(cellType: PosterCell.self)
        collectionView.register(reusableViewType: _SectionHeaderView.self)
    }
}

extension _HomeViewController {
    
    typealias DataSource = RxCollectionViewSectionedAnimatedDataSource<HomeViewModel.HomeSectionItem>
    
    private func dataSource() -> DataSource {
        return DataSource { dataSource, collectionView, indexPath, viewModel in
            let cell = collectionView.dequeueReusableCell(with: PosterCell.self, for: indexPath)
            cell.bind(viewModel)
            
            return cell
        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            let headerView = collectionView.dequeueReusableView(with: _SectionHeaderView.self, for: indexPath)
            let section = dataSource[indexPath.section].section
            let viewModel = SectionHeaderViewModel(with: section, index: indexPath.section)

            headerView.bind(viewModel)
            headerView.selection?
                .bind(to: self.selectedSection)
                .disposed(by: headerView.disposeBag)
            
            return headerView
        }
    }
        
    private func createCompositionalLayout(with homeSections: [HomeSection]) -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout {   sectionIndex, _ in
            var itemSize = NSCollectionLayoutSize(widthDimension: .absolute(CGFloat.leastNonzeroMagnitude),
                                                  heightDimension: .absolute(CGFloat.leastNonzeroMagnitude))
            var groupSize = NSCollectionLayoutSize(widthDimension: .absolute(CGFloat.leastNonzeroMagnitude),
                                                   heightDimension: .absolute(CGFloat.leastNonzeroMagnitude))

            guard let homeSection = homeSections[safe: sectionIndex] else {
                assertionFailure("section is nil")
                return NSCollectionLayoutSection(group: NSCollectionLayoutGroup(layoutSize: groupSize))
            }
            
            itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .estimated(homeSection.height))
            groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4),
                                               heightDimension: .estimated(homeSection.height))

            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 15
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 40, trailing: 20)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(100))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                            elementKind: UICollectionView.elementKindSectionHeader,
                                                                            alignment: .top)
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
        }
    }
}
