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
    
    lazy var collectionViewController: UICollectionViewController = {
        UICollectionViewController(collectionViewLayout: createCompositionalLayout())
    }()
        
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
        let input = ContentDetailViewModel.Input(ready: rx.viewWillAppear.asDriver())
        
        let selectedSection = PublishRelay<Int>()
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<ContentDetailViewModel.DetailSectionItem> { dataSource, collectionView, indexPath, viewModel in
            
            let section = dataSource[indexPath.section].section
            
            switch (section, viewModel) {
            case (.movie(.title), let vm as TitleCellViewModel),
                (.tvShow(.title), let vm as TitleCellViewModel):
                let cell: TitleCell = collectionView.dequeueReusableCell(with: TitleCell.self, for: indexPath)
                cell.bind(vm)
                return cell
            case (.movie(.recommendation), let vm as PosterItemViewModel),
                (.movie(.similar), let vm as PosterItemViewModel):
                let cell: HomePosterCell = collectionView.dequeueReusableCell(with: HomePosterCell.self, for: indexPath)
                cell.bind(vm)
                return cell
            default:
                return UICollectionViewCell()
            }
        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            let headerView: _SectionHeaderView = collectionView.dequeueReusableView(with: _SectionHeaderView.self, for: indexPath)
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
        
        output.posterImage
            .drive(blurPosterIv.rx.image)
            .disposed(by: disposeBag)
        
        output.posterImage
            .drive(posterIv.rx.image)
            .disposed(by: disposeBag)
        
        output.sectionItems
            .drive(collectionViewController.collectionView.rx.items(dataSource: dataSource))
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
        collectionViewController.collectionView.backgroundColor = .secondarySystemGroupedBackground
        collectionViewController.collectionView.register(cellType: TitleCell.self)
        collectionViewController.collectionView.register(cellType: HomePosterCell.self)
        collectionViewController.collectionView.register(reusableViewType: _SectionHeaderView.self)
        collectionViewController.collectionView.delegate = nil
        collectionViewController.collectionView.dataSource = nil

        let fpc = FloatingPanelController(delegate: self)
        fpc.layout = FloatingLayout()
        fpc.set(contentViewController: collectionViewController)
        fpc.track(scrollView: collectionViewController.collectionView)
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
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            if sectionIndex == 0 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                // 그룹
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .absolute(500))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 2)
                
                // 섹션
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                
                return section
            } else {
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
                
                return section
            }
        }
    }
}
