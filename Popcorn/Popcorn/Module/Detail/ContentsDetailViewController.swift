//
//  ContentsDetailViewController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/11/25.
//

import UIKit

class ContentsDetailViewController: BaseViewController {
    @IBOutlet private weak var blurPosterIv: UIImageView!
    @IBOutlet private weak var posterIv: UIImageView!
    
    var collectionView: UICollectionView?
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    var id: Int!
    var contents: Movie!
    var posterHeroId: String?
    
    var mediaType: ImageType = .backdrop
    var backdropInfos: [ImageInfo] = []
    var posterInfos: [ImageInfo] = []
    var videoInfos: [VideoInfo] = []
    var imageInfos: [ImageInfo] = []
    var credits: [Person] = []
    var recommendations: [Movie] = []
    var similars: [Movie] = []
    var infoItems: [InfoItem] = []
    var reviews: [Review] = []
    
    var detailSections: [DetailSectionItem] {
        var sections: [DetailSectionItem] = []
        
        var subtitle: String = ""
        
        // 개봉연도
        if let releaseDate = self.contents?.releaseDate.dateValue() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"
            let year = dateFormatter.string(from: releaseDate)

            subtitle = year
        }
        
        // original 제목
        if let originalTitle = self.contents?.originalTitle {
            subtitle += " · " + originalTitle
        }
        
        let genreNames = (contents?.genres ?? [Genre(id: 0, isLoading: true), Genre(id: 1, isLoading: true), Genre(id: 2, isLoading: true)]).compactMap { $0 }
        let titleSection = DetailSectionItem(.title(title: contents.title, subTitle: subtitle, voteAverage: self.contents?.voteAverage ?? 0, genres: genreNames), items: [])
        sections.append(titleSection)
        
        // 시놉시스 (tagline + overview)
        var synopsisInfo: [ListDiffable] = []
        if let tagline = contents?.tagline, !tagline.isEmpty {
            synopsisInfo.append((tagline + "\n") as ListDiffable)
        }
        
        if let overview = contents?.overview?.replacingOccurrences(of: ". ", with: ".\n"), !overview.isEmpty {
            synopsisInfo.append(overview as ListDiffable)
        }
        
        if synopsisInfo.count > 0 {
            let section = DetailSectionItem(.synopsis, items: synopsisInfo)
            sections.append(section)
        }
        
        // 출연 & 제작
        if credits.count > 0 {
            let section = DetailSectionItem(.credit, items: credits)
            sections.append(section)
        }
        
        // 상세정보
        if infoItems.count > 0 {
            let detailSection = DetailSectionItem(.detail, items: infoItems)
            sections.append(detailSection)
        }
        
        // 이미지 ( poster + backdrop )
        if imageInfos.count > 0 {
            let section = DetailSectionItem(.image(tabs: ImageType.allCases.map { $0.title }), items: imageInfos)
            sections.append(section)
        }
        
        // 비디오
        if videoInfos.count > 0 {
            let section = DetailSectionItem(.video, items: videoInfos)
            sections.append(section)
        }
        
        // 리뷰
        if reviews.count > 0 {
            let section = DetailSectionItem(.review, items: reviews)
            sections.append(section)
        }
        
        // 추천 작품
        if recommendations.count > 0 {
            let section = DetailSectionItem(.recommendation, items: recommendations)
            sections.append(section)
        }
        
        // 비슷한 작품
        if similars.count > 0 {
            let section = DetailSectionItem(.similar, items: similars)
            sections.append(section)
        }
        
        return sections
    }
    
    convenience init(id: Int) {
        self.init()
        self.id = id
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigation(title: contents?.title)
        
        posterIv.hero.id = posterHeroId
        posterIv.heroModifiers = [.spring(stiffness: 90, damping: 15)]
        
        setupFloatingPanel()
        setupUI()
        getMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setTransparent(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let index = detailSections.firstIndex(where: { $0.items is [ImageInfo] }), let sectionController = adapter.sectionController(forSection: index) as? DetailHorizontalSectionController {
            sectionController.headerAdapter.collectionView?.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setTransparent(false)
    }
    
    func setupFloatingPanel() {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let contentVC = UICollectionViewController(collectionViewLayout: layout)
        contentVC.collectionView.backgroundColor = .secondarySystemGroupedBackground

        collectionView = contentVC.collectionView
        adapter.collectionView = contentVC.collectionView
        adapter.dataSource = self

        let fpc = FloatingPanelController(delegate: self)
        fpc.layout = FloatingLayout()
        fpc.set(contentViewController: contentVC)
        fpc.track(scrollView: contentVC.collectionView)
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
    
    func setupUI() {
        DispatchQueue.main.async {
            self.blurPosterIv.applyBlur(style: .regular)
            self.posterIv.applyShadow()
            
            // poster 이미지
            if let path = self.contents?.posterPath, let url = URL(string: AppConstants.Domain.tmdbImage + path), self.posterIv.image == nil {
                Nuke.loadImage(with: url, options: ImageLoadingOptions.fadeIn, into: self.posterIv, completion: { result in
                    switch result {
                    case .success(let response):
                        self.blurPosterIv.image = response.image
                    case .failure(_):
                        break
                    }
                })
            }
        }
    }
    
    func getMovies() {
        var params: [String: Any] = [:]
        
        // 영화 상세 정보
        APIManager.request(AppConstants.API.Movie.getDetails(id), method: .get, params: params, responseType: Movie.self .self) { (result) in
            switch result {
            case .success(let response):
                self.contents = response

                self.infoItems = response.filteredInfo()
                self.adapter.performUpdates(animated: true, completion: nil)
            case .failure(let error):
                Log.d(error)
            }
        }
        
        // 관련 이미지(배경,포스터)
        APIManager.request(AppConstants.API.Movie.getImages(id), method: .get, params: nil, Localization: false, responseType: ListResponse.self) { (result) in
            switch result {
            case .success(let response):
                self.backdropInfos = response.backdrops ?? []
                self.posterInfos = response.posters ?? []
                
                let backdrops = response.backdrops ?? []
                let posters = response.posters ?? []
                
                backdrops.forEach { $0.type = .backdrop }
                posters.forEach { $0.type = .poster }
                
                self.imageInfos = backdrops + posters
                
                self.adapter.performUpdates(animated: true, completion: nil)
            case .failure(let error):
                Log.d(error)
            }
        }
        
        // 관련 비디오(유튜브)
        APIManager.request(AppConstants.API.Movie.getVideos(id), method: .get, params: nil, responseType: Response<VideoInfo>.self) { (result) in
            switch result {
            case .success(let response):
                self.videoInfos = response.results ?? []
                self.adapter.performUpdates(animated: true, completion: nil)
            case .failure(let error):
                Log.d(error)
            }
        }
        
        // 출연, 감독
        APIManager.request(AppConstants.API.Movie.getCredits(id), method: .get, params: nil, responseType: ListResponse.self) { (result) in
            switch result {
            case .success(let response):
                self.credits = response.cast ?? []
                // 감독을 맨 앞에 삽입
                if let director = response.crew?.filter({ $0.job == "Director" }).first {
                    self.credits.insert(director, at: 0)
                }
                
                self.adapter.performUpdates(animated: true, completion: nil)
            case .failure(let error):
                Log.d(error)
            }
        }
        
        // 추천목록
        APIManager.request(AppConstants.API.Movie.getRecommendations(id), method: .get, params: nil, responseType: PageResponse<Movie>.self) { (result) in
            switch result {
            case .success(let response):
                self.recommendations = response.results ?? []
                self.adapter.performUpdates(animated: true, completion: nil)
            case .failure(let error):
                Log.d(error)
            }
        }
        
        // 비슷한목록
        APIManager.request(AppConstants.API.Movie.getSimilar(id), method: .get, params: nil, responseType: PageResponse<Movie>.self) { (result) in
            switch result {
            case .success(let response):
                self.similars = response.results ?? []
                self.adapter.performUpdates(animated: true, completion: nil)
            case .failure(let error):
                Log.d(error)
            }
        }
        
        // 리뷰목록
        APIManager.request(AppConstants.API.Movie.getReviews(id), method: .get, params: nil, Localization: false, responseType: PageResponse<Review>.self) { (result) in
            switch result {
            case .success(let response):
                self.reviews = response.results ?? []
                self.adapter.performUpdates(animated: true, completion: nil)
            case .failure(let error):
                Log.d(error)
            }
        }
    }
}

extension ContentsDetailViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return detailSections
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return DetailHorizontalSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension ContentsDetailViewController: FloatingPanelControllerDelegate {
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

class FloatingLayout: FloatingPanelLayout {
    var position: FloatingPanelPosition = .bottom
    var initialState: FloatingPanelState = .half
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 10.0, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.3, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
}
