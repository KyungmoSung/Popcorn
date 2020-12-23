//
//  ContentsDetailViewController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/11/25.
//

import UIKit

enum MediaType: Int, CaseIterable {
    case backdrop
    case poster
    case video
    
    var title: String {
        switch self {
        case .backdrop:
            return "배경"
        case .poster:
            return "포스터"
        case .video:
            return "동영상"
        }
    }
}

class ContentsDetailViewController: BaseViewController {
    @IBOutlet private weak var statusBarView: UIView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var blurView: UIView!
    @IBOutlet private weak var blurPosterIv: UIImageView!
    @IBOutlet private weak var posterIv: UIImageView!
    
    @IBOutlet private weak var contentsView: UIView!
    @IBOutlet private weak var titleLb: UILabel!
    @IBOutlet private weak var subTitleLb: UILabel!
    @IBOutlet private weak var voteAverageLb: UILabel!
    @IBOutlet private weak var overviewLb: UILabel!
    
    @IBOutlet private weak var genreCollectionView: UICollectionView!
    @IBOutlet private weak var infoCollectionView: UICollectionView!
    @IBOutlet private weak var mediaTypeTabCollectionView: UICollectionView!
    @IBOutlet private weak var mediaListCollectionView: UICollectionView!
    @IBOutlet private weak var creditCollectionView: UICollectionView!
    @IBOutlet private weak var recommendationCollectionView: UICollectionView!
    @IBOutlet private weak var similarCollectionView: UICollectionView!
    
    lazy var genreAdapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    lazy var infoAdapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    lazy var mediaTypeAdapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    lazy var mediaListAdapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    lazy var creditAdapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    lazy var recommendationAdapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    lazy var similarAdapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    var id: Int!
    var contents: Movie?
    var posterHeroId: String?
    
    var mediaType: MediaType = .backdrop
    var backdropInfos: [ImageInfo] = []
    var posterInfos: [ImageInfo] = []
    var videoInfos: [VideoInfo] = []
    var credits: [Person] = []
    var recommendations: [Movie] = []
    var similars: [Movie] = []
    var infoItems: [InfoItem] = []
    
    convenience init(id: Int) {
        self.init()
        self.id = id
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigation(title: contents?.title)
        
        posterIv.hero.id = posterHeroId
        posterIv.heroModifiers = [.spring(stiffness: 90, damping: 15)]
        contentsView.hero.modifiers = [.delay(0.1), .translate(y: 500), .spring(stiffness: 80, damping: 12)]
        
        scrollView.delegate = self
        
        genreAdapter.collectionView = genreCollectionView
        genreAdapter.dataSource = self
        
        infoCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        infoAdapter.collectionView = infoCollectionView
        infoAdapter.dataSource = self
        
        mediaTypeTabCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        mediaTypeAdapter.collectionView = mediaTypeTabCollectionView
        mediaTypeAdapter.dataSource = self
        
        mediaListCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        mediaListAdapter.collectionView = mediaListCollectionView
        mediaListAdapter.dataSource = self
        
        creditCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        creditAdapter.collectionView = creditCollectionView
        creditAdapter.dataSource = self
        
        recommendationCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        recommendationAdapter.collectionView = recommendationCollectionView
        recommendationAdapter.dataSource = self
        
        similarCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        similarAdapter.collectionView = similarCollectionView
        similarAdapter.dataSource = self

        blurPosterIv.applyBlur(style: .dark)
        posterIv.applyShadow()
        
        setupUI()
        getMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setTransparent(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mediaTypeTabCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setTransparent(false)
        contentsView.hero.modifiers?.removeAll()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        scrollView.contentInset = UIEdgeInsets(top: blurView.frame.height, left: 0, bottom: 0, right: 0)

        contentsView.roundCorners([.topLeft, .topRight], radius: 25)
    }
    
    func setupUI() {
        DispatchQueue.main.async {
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
            
            // 제목
            if let title = self.contents?.title {
                self.titleLb.text = title
            }
            
            // original 제목
            if let originalTitle = self.contents?.originalTitle {
                self.subTitleLb.text = originalTitle
            }
            
            // 장르
            if let _ = self.contents?.genres {
                self.genreAdapter.performUpdates(animated: false) { (_) in
//                    let minimumInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
//                    self.genreCollectionView.centerContentHorizontalyByInsetIfNeeded(minimumInset: minimumInset)
                }
            }
            
            // 개봉연도
            if let releaseDate = self.contents?.releaseDate.dateValue() {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy"
                let year = dateFormatter.string(from: releaseDate)

                self.subTitleLb.text = year + " · " + (self.subTitleLb.text ?? "")
            }
//
//            // 상영시간
//            if let runtime = self.contents?.runtime {
//                self.subTitleLb.text = (self.subTitleLb.text ?? "") + " · \(runtime)분"
//            }
            
            
            // 평점
            if let voteAverage = self.contents?.voteAverage {
                self.voteAverageLb.text = "\(voteAverage)"
            }
            
            // 줄거리
            if let overview = self.contents?.overview {
                self.overviewLb.text = overview
            }
        }
    }
    
    func getMovies() {
        var params: [String: Any] = [:]
        
        // 영화 상세 정보
        params = [
            "api_key": AppConstants.Key.tmdb,
            "language": "ko",
            "page": 1,
            "region": "ko"
        ]
        APIManager.request(AppConstants.API.Movie.getDetails(id), method: .get, params: params, responseType: Movie.self .self) { (result) in
            switch result {
            case .success(let response):
                self.contents = response
                self.setupUI()
                
                self.infoItems = response.filteredInfo()
                self.infoAdapter.performUpdates(animated: true, completion: nil)
            case .failure(let error):
                Log.d(error)
            }
        }
        
        // 관련 이미지(배경,포스터)
        APIManager.request(AppConstants.API.Movie.getImages(id), method: .get, params: nil, responseType: ListResponse.self) { (result) in
            switch result {
            case .success(let response):
                self.backdropInfos = response.backdrops ?? []
                self.posterInfos = response.posters ?? []
                if self.mediaType == .backdrop || self.mediaType == .poster {
                    self.mediaListAdapter.performUpdates(animated: true, completion: nil)
                }
            case .failure(let error):
                Log.d(error)
            }
        }
        
        // 관련 비디오(유튜브)
        APIManager.request(AppConstants.API.Movie.getVideos(id), method: .get, params: nil, responseType: Response<VideoInfo>.self) { (result) in
            switch result {
            case .success(let response):
                self.videoInfos = response.results ?? []
                if self.mediaType == .video {
                    self.mediaListAdapter.performUpdates(animated: true, completion: nil)
                }
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
                
                self.creditAdapter.performUpdates(animated: true, completion: nil)
                
            case .failure(let error):
                Log.d(error)
            }
        }
        
        // 추천목록
        APIManager.request(AppConstants.API.Movie.getRecommendations(id), method: .get, params: nil, responseType: PageResponse<Movie>.self) { (result) in
            switch result {
            case .success(let response):
                self.recommendations = response.results ?? []
                
                self.recommendationAdapter.performUpdates(animated: true, completion: nil)
            case .failure(let error):
                Log.d(error)
            }
        }
        
        // 비슷한
        APIManager.request(AppConstants.API.Movie.getSimilar(id), method: .get, params: nil, responseType: PageResponse<Movie>.self) { (result) in
            switch result {
            case .success(let response):
                self.similars = response.results ?? []
                
                self.similarAdapter.performUpdates(animated: true, completion: nil)
            case .failure(let error):
                Log.d(error)
            }
        }
    }
    
    func changeMediaType(_ type: MediaType) {
        guard mediaType != type else {
            return
        }
        mediaType = type
        self.mediaListAdapter.performUpdates(animated: true, completion: nil)
        self.mediaListAdapter.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: false)
    }
}

extension ContentsDetailViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        switch listAdapter {
        case genreAdapter:
            return (contents?.genres ?? []).map { $0.name as ListDiffable }
        case infoAdapter:
            return infoItems
        case mediaTypeAdapter:
            return MediaType.allCases.map { $0.title as ListDiffable }
        case mediaListAdapter:
            switch mediaType {
            case .backdrop:
                return backdropInfos
            case .poster:
                return posterInfos
            case .video:
                return videoInfos
            }
        case creditAdapter:
            return credits
        case recommendationAdapter:
            return recommendations
        case similarAdapter:
            return similars
        default:
            return []
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch listAdapter {
        case genreAdapter:
            let section = TextTagSectionController()
            section.delegate = self
            return section
        case infoAdapter:
            return InfoCardSectionController()
        case mediaTypeAdapter:
            let section = TextTabSectionController()
            section.delegate = self
            return section
        case mediaListAdapter:
            return MediaSectionController(mediaType: mediaType)
        case creditAdapter:
            return CreditSectionController()
        case recommendationAdapter, similarAdapter:
            return EmbeddedSectionController(category: .none)
        default:
            return ListSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension ContentsDetailViewController: TextTagDelegate {
    func didSelectTag(index: Int) {
        if let genre = contents?.genres?[index] {
            print(genre)
        }
    }
}

extension ContentsDetailViewController: TextTabDelegate {
    func didSelectTab(index: Int) {
        if let type = MediaType(rawValue: index) {
            changeMediaType(type)
        }
    }
}

extension ContentsDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
            if scrollView.contentOffset.y + navigationBarHeight >= 0{
                UIView.animate(withDuration: 0.2) {
                    self.statusBarView.backgroundColor = .secondarySystemGroupedBackground
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.label]
                }
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.statusBarView.backgroundColor = .clear
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.clear]
                }
            }
        }
    }
}
