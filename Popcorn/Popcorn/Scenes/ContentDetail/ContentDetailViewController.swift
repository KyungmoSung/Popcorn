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
import RxKingfisher
import ReactorKit
import Then
import SnapKit

final class ContentDetailViewController: BaseViewController {
    
    // MARK: - UI Properties
    
    private let blurPosterIv = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let posterIv = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 40
    }
    
    var collectionViewController = UICollectionViewController(collectionViewLayout: UICollectionViewLayout())
    var collectionView: UICollectionView {
        return collectionViewController.collectionView
    }
    
    // MARK: - Properties
    
    let selectedSection = PublishRelay<Int>()
    let selectedAction = PublishRelay<ContentAction>()
    let selectedShare = PublishRelay<Void>()
    
    // MARK: - Initializer
    
    convenience init(reactor: ContentDetailViewReactor) {
        self.init()
        collectionView.delegate = nil
        collectionView.dataSource = nil
        self.reactor = reactor
    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupFloatingPanel()
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
    
    private func setupUI() {
        view.addSubview(blurPosterIv)
        blurPosterIv.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        blurPosterIv.applyBlur(style: .regular)
        
        let containerView = UIView()
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.7)
        }
        
        containerView.addSubview(posterIv)
        posterIv.snp.makeConstraints {
            $0.width.equalTo(posterIv.snp.height).multipliedBy(2.0/3.0)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.center.equalToSuperview()
        }
        posterIv.applyShadow()

    }
    
    private func setupFloatingPanel() {
        collectionView.backgroundColor = .secondarySystemGroupedBackground
        collectionView.register(cellType: TitleCell.self)
        collectionView.register(cellType: PosterCell.self)
        collectionView.register(cellType: CreditCell.self)
        collectionView.register(cellType: ImageCell.self)
        collectionView.register(cellType: VideoCell.self)
        collectionView.register(cellType: ReviewCell.self)
        collectionView.register(cellType: ReportCell.self)
        collectionView.register(cellType: SynopsisCell.self)
        collectionView.register(reusableViewType: SectionHeaderView.self)

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

// MARK: - FloatingPanelControllerDelegate

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

// MARK: - CollectionView DataSource & Layout

extension ContentDetailViewController {
    typealias DataSource = RxCollectionViewSectionedAnimatedDataSource<ContentDetailViewReactor.DetailSectionItem>
    
    private func dataSource() -> DataSource {
        return DataSource { dataSource, collectionView, indexPath, viewModel in
            let section = dataSource[indexPath.section].section
            
            switch (section, viewModel) {
            case let (.title, viewModel as TitleItemViewModel):
                let cell = collectionView.dequeueReusableCell(with: TitleCell.self, for: indexPath)
                cell.bind(viewModel)
                
                cell.actionSelection?
                    .bind(to: self.selectedAction)
                    .disposed(by: cell.disposeBag)
                
                cell.shareSelection?
                    .bind(to: self.selectedShare)
                    .disposed(by: cell.disposeBag)
                
                return cell
            case let (.synopsis, viewModel as SynopsisItemViewModel):
                let cell = collectionView.dequeueReusableCell(with: SynopsisCell.self, for: indexPath)
                cell.bind(viewModel)
                return cell
            case let (.report, viewModel  as ReportItemViewModel):
                let cell = collectionView.dequeueReusableCell(with: ReportCell.self, for: indexPath)
                cell.bind(viewModel)
                return cell
            case let (.credit, viewModel as CreditItemViewModel):
                let cell = collectionView.dequeueReusableCell(with: CreditCell.self, for: indexPath)
                cell.bind(viewModel)
                return cell
            case let (.image, viewModel as ImageItemViewModel):
                let cell = collectionView.dequeueReusableCell(with: ImageCell.self, for: indexPath)
                cell.bind(viewModel)
                return cell
            case let (.video, viewModel as VideoItemViewModel):
                let cell = collectionView.dequeueReusableCell(with: VideoCell.self, for: indexPath)
                cell.bind(viewModel)
                return cell
            case let (.recommendation, viewModel as PosterItemViewModel),
                let (.similar, viewModel as PosterItemViewModel):
                let cell = collectionView.dequeueReusableCell(with: PosterCell.self, for: indexPath)
                cell.bind(viewModel)
                return cell
            case let (.review, viewModel as ReviewItemViewModel):
                let cell = collectionView.dequeueReusableCell(with: ReviewCell.self, for: indexPath)
                cell.bind(viewModel)
                return cell
            default:
                return UICollectionViewCell()
            }
        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            let headerView = collectionView.dequeueReusableView(with: SectionHeaderView.self, for: indexPath)
            let section = dataSource[indexPath.section].section
            let viewModel = SectionHeaderViewModel(with: section, index: indexPath.section)
            
            headerView.bind(viewModel)
            
            headerView.selection?
                .bind(to: self.selectedSection)
                .disposed(by: headerView.disposeBag)
                 
            return headerView
        }
    }
    
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
            case .title:
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .estimated(100))
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                                   heightDimension: .estimated(100))
                behavior = .groupPaging
                
            case .synopsis:
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .estimated(100))
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .estimated(100))
                behavior = .none
                
            case .credit:
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .estimated(detailSection.height))
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                                   heightDimension: .estimated(detailSection.height))
                
            case .report:
                itemSize = NSCollectionLayoutSize(widthDimension: .estimated(detailSection.height),
                                                  heightDimension: .fractionalHeight(1))
                groupSize = NSCollectionLayoutSize(widthDimension: .estimated(detailSection.height),
                                                   heightDimension: .absolute(detailSection.height))
                
            case .video:
                itemSize = NSCollectionLayoutSize(widthDimension: .estimated(detailSection.height),
                                                  heightDimension: .fractionalHeight(1))
                groupSize = NSCollectionLayoutSize(widthDimension: .estimated(detailSection.height),
                                                   heightDimension: .absolute(detailSection.height))
                
            case .image:
                itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                                  heightDimension: .fractionalHeight(1))
                groupSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                                   heightDimension: .absolute(detailSection.height))
                
            case .similar,
                 .recommendation:
                itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .estimated(detailSection.height))
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                                   heightDimension: .estimated(detailSection.height))
                
            case .review:
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

// MARK: - Bind Reactor

extension ContentDetailViewController: View {
    func bind(reactor: ContentDetailViewReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
        //        posterIv.hero.id = viewModel.heroID
    }
    
    private func bindAction(reactor: ContentDetailViewReactor) {
        rx.viewDidLoad
            .map { Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rx.viewWillAppear
            .map { Reactor.Action.appear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        localizeChanged
            .map { Reactor.Action.localizeChanged }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectedSection
            .map { Reactor.Action.selectHeader($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectedAction
            .filter { $0 == .rate }
            .map { _ in Reactor.Action.rating }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectedShare
            .map { Reactor.Action.share }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectedAction
            .filter { $0 == .favorite }
            .map { _ in Reactor.Action.markFavorite }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        selectedAction
            .filter { $0 == .watchlist }
            .map { _ in Reactor.Action.markWatchList }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(RowViewModel.self)
            .map { Reactor.Action.selectItem($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindState(reactor: ContentDetailViewReactor) {
        reactor.state
            .compactMap { $0.posterImageURL }
            .asDriverOnErrorJustComplete()
            .drive(blurPosterIv.kf.rx.image(options: [.transition(.fade(1))]))
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.posterImageURL }
            .asDriverOnErrorJustComplete()
            .drive(posterIv.kf.rx.image(options: [.transition(.fade(1))]))
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.sectionItems }
            .asDriverOnErrorJustComplete()
            .map{ $0.map { $0.section } }
            .drive { [weak self] sections in
                guard let self = self else { return }
                self.collectionView.collectionViewLayout = self.createCompositionalLayout(with: sections)
            }
            .disposed(by: disposeBag)

        reactor.state
            .debug("datasource")
            .map { $0.sectionItems }
            .asDriverOnErrorJustComplete()
            .drive(collectionView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.accountStates }
            .asDriverOnErrorJustComplete()
            .drive()
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLoading }
            .asDriverOnErrorJustComplete()
            .drive()
            .disposed(by: disposeBag)
        
    }

}
