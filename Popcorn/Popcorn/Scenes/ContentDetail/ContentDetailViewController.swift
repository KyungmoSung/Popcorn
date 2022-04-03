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
import Hero
import RxKingfisher
import ReactorKit
import Then
import SnapKit

final class ContentDetailViewController: BaseViewController {
    
    // MARK: - UI Properties
    
    private let topGradientView = UIView()
    private let bottomGradientView = UIView()
    
    private let posterIv = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private let titleView = UIView()
    
    private let titleLb = UILabel()
    private let subTitleLb = UILabel()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        $0.backgroundColor = .secondarySystemGroupedBackground
        $0.contentInsetAdjustmentBehavior = .never
        
        $0.register(cellType: TitleCell.self)
        $0.register(cellType: PosterCell.self)
        $0.register(cellType: CreditCell.self)
        $0.register(cellType: ImageCell.self)
        $0.register(cellType: VideoCell.self)
        $0.register(cellType: ReviewCell.self)
        $0.register(cellType: ReportCell.self)
        $0.register(cellType: SynopsisCell.self)
        $0.register(reusableViewType: SectionHeaderView.self)
    }
    
    private let scrollView = UIScrollView().then {
        $0.contentInsetAdjustmentBehavior = .never
    }
    
    // MARK: - Properties
    
    let selectedSection = PublishRelay<Int>()
//    let selectedAction = PublishRelay<ContentAction>()
//    let selectedShare = PublishRelay<Void>()
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
              
        let gradientColors: [UIColor] = [.secondarySystemGroupedBackground.withAlphaComponent(1),
                                        .secondarySystemGroupedBackground.withAlphaComponent(0)]
        
        topGradientView.setGradient(colors: gradientColors)
        bottomGradientView.setGradient(colors: gradientColors.reversed())
        
        let contentHeight = collectionView.contentSize.height
        
        if contentHeight > 0 {
            collectionView.snp.remakeConstraints { make in
                make.top.equalToSuperview().inset(posterIv.bounds.height)
                make.top.lessThanOrEqualTo(posterIv.snp.bottom)
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(contentHeight)
            }
        }
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let containerView = UIView()
        scrollView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
            make.height.equalToSuperview().priority(.low)
        }

        containerView.addSubview(posterIv)
        posterIv.snp.remakeConstraints {
            $0.width.equalTo(posterIv.snp.height).multipliedBy(2.0/3.0)
            $0.top.equalToSuperview().priority(.low)
            $0.top.equalTo(view.snp.top)
            $0.left.right.equalToSuperview()
        }

        containerView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.lessThanOrEqualTo(posterIv.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        view.addSubview(topGradientView)
        topGradientView.snp.remakeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
            
        }
        
        containerView.addSubview(bottomGradientView)
        bottomGradientView.snp.remakeConstraints {
            $0.bottom.equalTo(collectionView.snp.top)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(100)
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
            case let (.title, cellReactor as TitleCellReactor):
                let cell = collectionView.dequeueReusableCell(with: TitleCell.self, for: indexPath)
                cell.reactor = cellReactor
                
//                if let reactor = self.reactor {
//                    cellReactor.action
//                        .subscribe(onNext: { action in
//                            switch action {
//                            case .rating:
//                                Observable.just(())
//                                    .map { Reactor.Action.showRating }
//                                    .bind(to: reactor.action)
//                                    .disposed(by: cell.disposeBag)
//                                
//                            case .share:
//                                Observable.just(())
//                                    .map { Reactor.Action.share }
//                                    .bind(to: reactor.action)
//                                    .disposed(by: cell.disposeBag)
//                            default:
//                                break
//                            }
//                        }).disposed(by: cell.disposeBag)
//                }
                
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
        
        
//        selectedAction
//            .filter { $0 == .favorite }
//            .map { _ in Reactor.Action.markFavorite }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
//
//        selectedAction
//            .filter { $0 == .watchlist }
//            .map { _ in Reactor.Action.markWatchList }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(RowViewModel.self)
            .map { Reactor.Action.selectItem($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindState(reactor: ContentDetailViewReactor) {
        reactor.state
            .compactMap { $0.content.posterPath }
            .compactMap { URL(string: AppConstants.Domain.tmdbImage + $0) }
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
            .map { $0.sectionItems }
            .debug("datasource")
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
