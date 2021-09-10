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
        let selectedSection = PublishRelay<Int>()

        let input = ContentDetailViewModel.Input(ready: rx.viewWillAppear.asObservable(),
                                                 localizeChanged: localizeChanged.asObservable(),
                                                 headerSelection: selectedSection.asObservable(),
                                                 selection: collectionView.rx.modelSelected(RowViewModel.self).asObservable())

        let dataSource = RxCollectionViewSectionedReloadDataSource<ContentDetailViewModel.DetailSectionItem> { dataSource, collectionView, indexPath, viewModel in
            
            let section = dataSource[indexPath.section].section
            
            switch (section, viewModel) {
            case let (.movie(.title), viewModel as TitleCellViewModel),
                 let (.tvShow(.title), viewModel as TitleCellViewModel):
                let cell = collectionView.dequeueReusableCell(with: TitleCell.self, for: indexPath)
                cell.bind(viewModel)
                return cell
            case let (.movie(.synopsis), viewModel as SynopsisViewModel),
                 let (.tvShow(.synopsis), viewModel as SynopsisViewModel):
                let cell = collectionView.dequeueReusableCell(with: _SynopsisCell.self, for: indexPath)
                cell.bind(viewModel)
                return cell
            case let (.movie(.report), viewModel  as ReportCellViewModel),
                 let (.tvShow(.report), viewModel  as ReportCellViewModel):
                let cell = collectionView.dequeueReusableCell(with: ReportCell.self, for: indexPath)
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
                let (.movie(.similar), viewModel as PosterItemViewModel),
                let (.tvShow(.recommendation), viewModel as PosterItemViewModel),
                let (.tvShow(.similar), viewModel as PosterItemViewModel):
                let cell = collectionView.dequeueReusableCell(with: HomePosterCell.self, for: indexPath)
                cell.bind(viewModel)
                return cell
            case let (.movie(.review), viewModel as ReviewCellViewModel),
                 let (.tvShow(.review), viewModel as ReviewCellViewModel):
                let cell = collectionView.dequeueReusableCell(with: _ReviewCell.self, for: indexPath)
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
            .asDriverOnErrorJustComplete()
            .drive(blurPosterIv.rx.image)
            .disposed(by: disposeBag)
        
        output.posterImage
            .asDriverOnErrorJustComplete()
            .drive(posterIv.rx.image)
            .disposed(by: disposeBag)
        
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
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.selectedContent
            .asDriverOnErrorJustComplete()
            .drive()
            .disposed(by: disposeBag)
        
        posterIv.hero.id = viewModel.heroID
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
        posterIv.applyShadow()
        blurPosterIv.applyBlur(style: .regular)
    }
    
    func setupFloatingPanel() {
        collectionView.backgroundColor = .secondarySystemGroupedBackground
        collectionView.register(cellType: TitleCell.self)
        collectionView.register(cellType: HomePosterCell.self)
        collectionView.register(cellType: _CreditCell.self)
        collectionView.register(cellType: ImageCell.self)
        collectionView.register(cellType: VideoCell.self)
        collectionView.register(cellType: _ReviewCell.self)
        collectionView.register(cellType: ReportCell.self)
        collectionView.register(cellType: _SynopsisCell.self)
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
    private func createCompositionalLayout(with detailSections: [DetailSection]) -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            var itemSize = NSCollectionLayoutSize(widthDimension: .absolute(CGFloat.leastNonzeroMagnitude),
                                                  heightDimension: .absolute(CGFloat.leastNonzeroMagnitude))
            var groupSize = NSCollectionLayoutSize(widthDimension: .absolute(CGFloat.leastNonzeroMagnitude),
                                                   heightDimension: .absolute(CGFloat.leastNonzeroMagnitude))

            var behavior: UICollectionLayoutSectionOrthogonalScrollingBehavior = .continuous
            
            guard let detailSection = detailSections[safe: sectionIndex] else {
                assertionFailure("section is nil")
                return NSCollectionLayoutSection(group: NSCollectionLayoutGroup(layoutSize:groupSize))
            }

            switch detailSection {
            case .movie(.title), .tvShow(.title):
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .estimated(100))
                
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                                   heightDimension: .estimated(100))
                behavior = .groupPaging
                
            case .movie(.synopsis), .tvShow(.synopsis):
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .estimated(100))
                
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .estimated(100))
                behavior = .none
                
            case .movie(.credit), .tvShow(.credit):
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .estimated(detailSection.height))
                
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                                   heightDimension: .estimated(detailSection.height))
                
            case .movie(.report), .tvShow(.report):
                itemSize = NSCollectionLayoutSize(widthDimension: .estimated(detailSection.height),
                                                  heightDimension: .fractionalHeight(1))
                
                groupSize = NSCollectionLayoutSize(widthDimension: .estimated(detailSection.height),
                                                   heightDimension: .absolute(detailSection.height))
                
            case .movie(.video), .tvShow(.video):
                itemSize = NSCollectionLayoutSize(widthDimension: .estimated(detailSection.height),
                                                  heightDimension: .fractionalHeight(1))
                
                groupSize = NSCollectionLayoutSize(widthDimension: .estimated(detailSection.height),
                                                   heightDimension: .absolute(detailSection.height))
                
            case .movie(.image), .tvShow(.image):
                itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                                  heightDimension: .fractionalHeight(1))
                
                groupSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                                   heightDimension: .absolute(detailSection.height))
                
            case .movie(.similar), .tvShow(.similar),
                 .movie(.recommendation), .tvShow(.recommendation):
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .estimated(detailSection.height))
                
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                                   heightDimension: .estimated(detailSection.height))
                
            case .movie(.review), .tvShow(.review):
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
                
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                                   heightDimension: .absolute(detailSection.height))
                behavior = .groupPaging
                
            default:
                break
            }
            
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = behavior
            section.interGroupSpacing = 15
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 40, trailing: 20)
            
            if let _ = detailSection.title { // 헤더
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .estimated(100))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                                elementKind: UICollectionView.elementKindSectionHeader,
                                                                                alignment: .top)
                section.boundarySupplementaryItems = [sectionHeader]
            }
            
            return section
        }
    }
}
