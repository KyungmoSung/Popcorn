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
    
    convenience init(viewModel: HomeViewModel) {
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
        collectionView.register(cellType: HomeBackdropCell.self)
        collectionView.register(reusableViewType: _SectionHeaderView.self,
                                ofKind: UICollectionView.elementKindSectionHeader)
    }
    
    private func bindViewModel() {
        title = viewModel.contentsType.title
        
        let input = HomeViewModel.Input(ready: rx.viewWillAppear.take(1).asObservable(),
                                        localizeChanged: localizeChanged.asObservable(),
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
}

extension _HomeViewController {
    
    typealias DataSource = RxCollectionViewSectionedAnimatedDataSource<HomeViewModel.HomeSectionItem>
    
    private func dataSource() -> DataSource {
        return DataSource { dataSource, collectionView, indexPath, viewModel in
            switch viewModel {
            case let viewModel as BackdropItemViewModel:
                let cell = collectionView.dequeueReusableCell(with: HomeBackdropCell.self, for: indexPath)
                cell.bind(viewModel)
                return cell
            case let viewModel as PosterItemViewModel:
                let cell = collectionView.dequeueReusableCell(with: PosterCell.self, for: indexPath)
                cell.bind(viewModel)
                return cell
            default:
                return UICollectionViewCell()
            }
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
            default:
                return UICollectionReusableView()
            }
        }
    }
        
    private func createCompositionalLayout(with homeSections: [HomeSection]) -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, env in
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
            let groupSize: NSCollectionLayoutSize
            let scrollBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior
            let itemSpacing: CGFloat = 10
            
            let sideInset: CGFloat = 20
            let contentWidth: CGFloat = env.container.contentSize.width
            let contentWidthWithouInset: CGFloat = contentWidth - (sideInset * 2)
            
            switch homeSection.displayType {
            case .backdrop:
                groupSize = NSCollectionLayoutSize(widthDimension: .absolute(contentWidthWithouInset),
                                                   heightDimension: .estimated(homeSection.height))
                scrollBehavior = .groupPaging
            case .poster:
                let numberOfvisibleItem: CGFloat = 3
                // 양쪽 Inset, Item간 Spacing 을 제외한 실제 크기 계산
                let groupWidth = (contentWidthWithouInset / numberOfvisibleItem) - (itemSpacing / numberOfvisibleItem * (numberOfvisibleItem - 1))
                groupSize = NSCollectionLayoutSize(widthDimension: .absolute(groupWidth),
                                                   heightDimension: .estimated(homeSection.height))
                scrollBehavior = .continuous
            }
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = scrollBehavior
            section.interGroupSpacing = itemSpacing
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: sideInset, bottom: 20, trailing: sideInset)
            
            // Header
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
