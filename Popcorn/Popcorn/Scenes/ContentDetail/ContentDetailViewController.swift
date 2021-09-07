//
//  ContentDetailViewController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/11/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import FloatingPanel
import Hero

class ContentDetailViewController: _BaseViewController {
    var viewModel: ContentDetailViewModel!
    
    @IBOutlet private weak var blurPosterIv: UIImageView!
    @IBOutlet private weak var posterIv: UIImageView!
    
    var collectionViewController = UICollectionViewController(collectionViewLayout: UICollectionViewLayout())
    var collectionView: UICollectionView {
        return collectionViewController.collectionView
    }
        
    convenience init(viewModel: ContentDetailViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupFloatingPanel()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let localizeChanged = Observable.merge(languageChanged.asObservable(),
                                               regionChanged.asObservable())
        
        let selectedSection = PublishRelay<Int>()

        let input = ContentDetailViewModel.Input(ready: rx.viewWillAppear.asDriver(),
                                                 headerSelection: selectedSection.asDriver(onErrorDriveWith: .empty()))

        let dataSource = RxCollectionViewSectionedReloadDataSource<ContentDetailViewModel.DetailSectionItem> { dataSource, collectionView, indexPath, viewModel in
            
            let section = dataSource[indexPath.section].section
            
            switch (section, viewModel) {
            case let (.movie(.title), viewModel as TitleCellViewModel),
                 let (.tvShow(.title), viewModel as TitleCellViewModel):
                let cell = collectionView.dequeueReusableCell(with: TitleCell.self, for: indexPath)
                cell.bind(viewModel)
                return cell
            case let (.movie(.credit), viewModel as CreditCellViewModel),
                 let (.tvShow(.credit), viewModel as CreditCellViewModel):
                let cell = collectionView.dequeueReusableCell(with: _CreditCell.self, for: indexPath)
                cell.bind(viewModel)
                return cell
            case let (.movie(.image), viewModel as ImageCellViewModel),
                 let (.tvShow(.image), viewModel as ImageCellViewModel):
                let cell = collectionView.dequeueReusableCell(with: ImageCell.self, for: indexPath)
                cell.bind(viewModel)
                return cell
            case let (.movie(.video), viewModel as VideoCellViewModel),
                 let (.tvShow(.video), viewModel as VideoCellViewModel):
                let cell = collectionView.dequeueReusableCell(with: VideoCell.self, for: indexPath)
                cell.bind(viewModel)
                return cell
            case let (.movie(.recommendation), viewModel as PosterItemViewModel),
                 let (.movie(.similar), viewModel as PosterItemViewModel):
                let cell = collectionView.dequeueReusableCell(with: HomePosterCell.self, for: indexPath)
                cell.bind(viewModel)
                return cell
            default:
                return UICollectionViewCell()
            }
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
        
        output.posterImage
            .drive(blurPosterIv.rx.image)
            .disposed(by: disposeBag)
        
        output.posterImage
            .drive(posterIv.rx.image)
            .disposed(by: disposeBag)
        
        output.sectionItems
            .map{ $0.map { $0.section } }
            .drive { [weak self] sections in
                guard let self = self else { return }
                self.collectionView.setCollectionViewLayout(self.createCompositionalLayout(with: sections), animated: false)
            }
            .disposed(by: disposeBag)
        
        output.sectionItems
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setTransparent(true)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.clear]

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setTransparent(false)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.label]
    }
    
    func setupUI() {
//        posterIv.hero.id = posterHeroId
        
        self.posterIv.applyShadow()
        self.blurPosterIv.applyBlur(style: .regular)
    }
    
    func setupFloatingPanel() {
        collectionView.backgroundColor = .secondarySystemGroupedBackground
        collectionView.register(cellType: TitleCell.self)
        collectionView.register(cellType: HomePosterCell.self)
        collectionView.register(cellType: _CreditCell.self)
        collectionView.register(cellType: ImageCell.self)
        collectionView.register(cellType: VideoCell.self)
        collectionView.register(reusableViewType: _SectionHeaderView.self)
        collectionView.delegate = nil
        collectionView.dataSource = nil

        let fpc = FloatingPanelController(delegate: self)
        fpc.layout = FloatingLayout()
        fpc.set(contentViewController: collectionViewController)
        fpc.track(scrollView: collectionView)
        fpc.addPanel(toParent: self)

        let shadow = SurfaceAppearance.Shadow()
        shadow.color = UIColor.black
        shadow.offset = CGSize(width: 0, height: 16)
        shadow.radius = 20
        shadow.spread = 0
        shadow.opacity = 1

        let appearance = SurfaceAppearance()
        appearance.shadows = [shadow]
        appearance.cornerRadius = 20
        appearance.backgroundColor = .clear

        fpc.surfaceView.appearance = appearance

        fpc.view.hero.modifiers = [
            .when({ (context) -> Bool in
                return context.isPresenting && context.isAppearing // 화면이 처음 보여지는 경우에만 애니메이션 적용
            }, .translate(y: 500), .spring(stiffness: 80, damping: 12))
        ]
    }
}

extension ContentDetailViewController: FloatingPanelControllerDelegate {
    func floatingPanelWillEndDragging(_ fpc: FloatingPanelController, withVelocity velocity: CGPoint, targetState: UnsafeMutablePointer<FloatingPanelState>) {
        switch targetState.pointee {
        case .full:
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.label]
            }
        case .half:
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.clear]
            }
        default:
            break
        }
    }
}

extension ContentDetailViewController {
    private func createCompositionalLayout(with sections: [DetailSection]) -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = sections[safe: sectionIndex] else {
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(0),
                                                       heightDimension: .absolute(0))
                return NSCollectionLayoutSection(group: NSCollectionLayoutGroup(layoutSize:groupSize))
            }
            
            switch section {
            case .movie(.title), .tvShow(.title):
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                // 그룹
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .absolute(500))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                // 섹션
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
                
                return section
                
            case .movie(.credit), .tvShow(.credit):
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                // 그룹
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                                       heightDimension: .absolute(section.height))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                // 섹션
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 15
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
                
                // 헤더
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .absolute(55))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                                elementKind: UICollectionView.elementKindSectionHeader,
                                                                                alignment: .top)
                section.boundarySupplementaryItems = [sectionHeader]
                
                return section
                
            case .movie(.video), .tvShow(.video):
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                // 그룹
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                                       heightDimension: .absolute(section.height))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                // 섹션
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 15
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
                
                // 헤더
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .absolute(55))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                                elementKind: UICollectionView.elementKindSectionHeader,
                                                                                alignment: .top)
                section.boundarySupplementaryItems = [sectionHeader]
                
                return section
                
            case .movie(.image), .tvShow(.image):
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(500),
                                                      heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                // 그룹
                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(500),
                                                       heightDimension: .absolute(section.height))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                // 섹션
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 15
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 2)
                
                // 헤더
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .estimated(50))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                                elementKind: UICollectionView.elementKindSectionHeader,
                                                                                alignment: .top)
                section.boundarySupplementaryItems = [sectionHeader]
                
                return section
            case .movie(.similar), .movie(.recommendation), .tvShow(.similar), .tvShow(.recommendation):
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
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
                
                // 헤더
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .absolute(55))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                                elementKind: UICollectionView.elementKindSectionHeader,
                                                                                alignment: .top)
                section.boundarySupplementaryItems = [sectionHeader]
                
                return section
                
            default:
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
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
                
                // 헤더
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .absolute(55))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                                elementKind: UICollectionView.elementKindSectionHeader,
                                                                                alignment: .top)
                section.boundarySupplementaryItems = [sectionHeader]
                
                return section
                
            }
        }
    }
}
