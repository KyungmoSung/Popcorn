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
    
    var posterHeroId: String?
    var posterHeroImage: UIImage?
        
    convenience init(viewModel: ContentDetailViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//
//        // 장르 ID값으로 Config에서 해당 장르 세팅
//        if let genreIDS = contents.genreIDS, !genreIDS.isEmpty {
//            var genres: [Genre] = []
//            let allGenres = Config.shared.allGenres(for: contentsType)
//
//            for genreID in genreIDS {
//                if let genre = allGenres?.first(where: { $0.id == genreID }) {
//                    genres.append(genre)
//                }
//            }
//
//            contents.genres = genres
//        }
//
//        // 각 타입별 섹션 아이템 세팅
//        switch contents {
//        case let movie as Movie:
//            setNavigation(title: movie.title)
//
//            for sectionType in Section.Detail.Movie.allCases {
//                if sectionType == .title {
//                    sectionItems.append(SectionItem(sectionType, items: [contents]))
//                } else {
//                    sectionItems.append(SectionItem(sectionType))
//                }
//            }
//
//            requestInfo(for: Section.Detail.Movie.allCases)
//        case let tvShow as TVShow:
//            setNavigation(title: tvShow.name)
//
//            for sectionType in Section.Detail.TVShow.allCases {
//                if sectionType == .title {
//                    sectionItems.append(SectionItem(sectionType, items: [contents]))
//                } else {
//                    sectionItems.append(SectionItem(sectionType))
//                }
//            }
//
//            requestInfo(for: Section.Detail.TVShow.allCases)
//        default:
//            break
//        }
        
        setupUI()
        setupFloatingPanel()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let localizeChanged = Observable.merge(languageChanged.asObservable(),
                                               regionChanged.asObservable())
        let input = ContentDetailViewModel.Input(ready: rx.viewWillAppear.asDriver())
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<ContentDetailViewModel.DetailSectionItem> { dataSource, collectionView, indexPath, viewModel in
            
            let section = dataSource[indexPath.section].section
            
            switch (section, viewModel) {
            case (.movie(.title), let vm as TitleCellViewModel),
                (.tvShow(.title), let vm as TitleCellViewModel):
                let cell: TitleCell = collectionView.dequeueReusableCell(with: TitleCell.self, for: indexPath)
                cell.bind(vm)
                return cell
            default:
                return UICollectionViewCell()
            }
        }
        
        let output = viewModel.transform(input: input)
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
        posterIv.hero.id = posterHeroId
        
        DispatchQueue.main.async {
            self.posterIv.image = self.posterHeroImage
            self.posterIv.applyShadow()
            
            self.blurPosterIv.image = self.posterHeroImage
            self.blurPosterIv.applyBlur(style: .regular)
            
//            // poster 이미지
//            if let path = self.contents?.posterPath, let url = URL(string: AppConstants.Domain.tmdbImage + path), self.posterIv.image == nil {
//                Nuke.loadImage(with: url, options: ImageLoadingOptions.fadeIn, into: self.posterIv, completion: { result in
//                    switch result {
//                    case .success(let response):
//                        self.blurPosterIv.image = response.image
//                    case .failure(_):
//                        break
//                    }
//                })
//            }
        }
        
//        setupFloatingPanel()
    }
    
    func setupFloatingPanel() {
        collectionViewController.collectionView.backgroundColor = .secondarySystemGroupedBackground
        collectionViewController.collectionView.register(cellType: TitleCell.self)
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
    
//    func updateSectionItems(_ items: [ListDiffable], at index: Int) {
//        let sectionItem = self.sectionItems[index]
//        sectionItem.items = items
//
//        if let sc = self.adapter.sectionController(for: sectionItem) as? DetailHorizontalSectionController {
//            sc.collectionContext?.performBatch(animated: true, updates: { (batchContext) in
//                batchContext.reload(sc)
//            })
//        }
//    }
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
            //            switch sectionIndex {
            //            case 0:
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
            //            default:
            
        }
    }
}
