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
        collectionView.register(reusableViewType: _SectionHeaderView.self,
                                ofKind: UICollectionView.elementKindSectionHeader)
        collectionView.register(reusableViewType: SectionLineFooterView.self,
                                ofKind: UICollectionView.elementKindSectionFooter)
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
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let headerView = collectionView.dequeueReusableView(with: _SectionHeaderView.self, for: indexPath, ofKind: kind)
                let section = dataSource[indexPath.section].section
                let viewModel = SectionHeaderViewModel(with: section, index: indexPath.section)

                headerView.bind(viewModel)
                headerView.selection?
                    .bind(to: self.selectedSection)
                    .disposed(by: headerView.disposeBag)
                
                return headerView
            case UICollectionView.elementKindSectionFooter:
                let footerView = collectionView.dequeueReusableView(with: SectionLineFooterView.self, for: indexPath, ofKind: kind)
                return footerView
            default:
                return UICollectionReusableView()
            }
        }
    }
        
    private func createCompositionalLayout(with homeSections: [HomeSection]) -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20

        return UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, env in
            guard let homeSection = homeSections[safe: sectionIndex] else {
                assertionFailure("section is nil")
                let config = UICollectionLayoutListConfiguration(appearance: .plain)
                return NSCollectionLayoutSection.list(using: config, layoutEnvironment: env)
            }
            
            // Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .estimated(homeSection.height))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            // Group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4),
                                               heightDimension: .estimated(homeSection.height))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 15
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            
            // Header
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .estimated(100))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                            elementKind: UICollectionView.elementKindSectionHeader,
                                                                            alignment: .top)
            
            // Footer
            let lineFooterHeight = 1 / env.traitCollection.displayScale
            let lineFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                        heightDimension: .absolute(lineFooterHeight))

            let sectionLineFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: lineFooterSize,
                                                                                elementKind: UICollectionView.elementKindSectionFooter,
                                                                                alignment: .bottom)

            section.boundarySupplementaryItems = [sectionHeader, sectionLineFooter]
            
            return section
        }, configuration: config)
    }
}
