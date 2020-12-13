//
//  ContentsDetailViewController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/11/25.
//

import UIKit

enum MediaType: Int, CaseIterable {
    case image
    case video
    
    var title: String {
        switch self {
        case .image:
            return "배경"
        case .video:
            return "동영상"
        }
    }
}

class ContentsDetailViewController: UIViewController {
    @IBOutlet private weak var backdropIv: UIImageView!
    @IBOutlet private weak var posterIv: UIImageView!
    @IBOutlet private weak var titleLb: UILabel!
    @IBOutlet private weak var originalTitleLb: UILabel!
    @IBOutlet private weak var genreLb: UILabel!
    @IBOutlet private weak var releaseDateLb: UILabel!
    @IBOutlet private weak var runtimeLb: UILabel!
    @IBOutlet private weak var voteAverageLb: UILabel!
    @IBOutlet private weak var voteCountLb: UILabel!
    @IBOutlet private weak var overviewLb: UILabel!
    @IBOutlet weak var mediaTypeTabCollectionView: UICollectionView!
    @IBOutlet weak var mediaListCollectionView: UICollectionView!
    @IBOutlet weak var creditCollectionView: UICollectionView!
    
    lazy var mediaTypeAdapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    lazy var mediaListAdapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    lazy var creditAdapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    var id: Int!
    var contents: Movie?
    var mediaType: MediaType = .image
    var imageInfos: [ImageInfo] = []
    var videoInfos: [VideoInfo] = []
    var credits: [Person] = []
    
    convenience init(id: Int) {
        self.init()
        self.id = id
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mediaTypeAdapter.collectionView = mediaTypeTabCollectionView
        mediaTypeAdapter.dataSource = self
        
        mediaListAdapter.collectionView = mediaListCollectionView
        mediaListAdapter.dataSource = self
        
        creditAdapter.collectionView = creditCollectionView
        creditAdapter.dataSource = self

        setupUI()
        getMovies()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mediaTypeTabCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
    func setupUI() {
        DispatchQueue.main.async {
            // 상단 backdrop 이미지
            if let path = self.contents?.backdropPath, let url = URL(string: AppConstants.Domain.tmdbImage + path), self.backdropIv.image == nil {
                Nuke.loadImage(with: url, options: ImageLoadingOptions.fadeIn, into: self.backdropIv)
            }
            
            // poster 이미지
            if let path = self.contents?.posterPath, let url = URL(string: AppConstants.Domain.tmdbImage + path), self.posterIv.image == nil {
                Nuke.loadImage(with: url, options: ImageLoadingOptions.fadeIn, into: self.posterIv)
            }
            
            // 제목
            if let title = self.contents?.title {
                self.titleLb.text = title
            }
            
            // original 제목
            if let originalTitle = self.contents?.originalTitle {
                self.originalTitleLb.text = originalTitle
            }
            
            // 장르
            if let genres = self.contents?.genres {
                var genresStr = ""
                genres.compactMap { $0.name }.forEach {
                    if genresStr.isEmpty {
                        genresStr += $0
                    } else {
                        genresStr += (", " + $0)
                    }
                }
                
                self.genreLb.text = genresStr
            }
                    
            
            // 개봉일
            if let releaseDate = self.contents?.releaseDate {
                self.releaseDateLb.text = releaseDate
            }
            
            // 상영시간
            if let runtime = self.contents?.runtime {
                self.runtimeLb.text = "\(runtime)분"
            }
            
            // 평점
            if let voteAverage = self.contents?.voteAverage {
                self.voteAverageLb.text = "\(voteAverage)"
            }
            
            // 평가자수
            if let voteCount = self.contents?.voteCount {
                self.voteCountLb.text = "\(voteCount)"
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
            case .failure(let error):
                Log.d(error)
            }
        }
        
        // 관련 이미지
        APIManager.request(AppConstants.API.Movie.getImages(id), method: .get, params: nil, responseType: ListResponse.self) { (result) in
            switch result {
            case .success(let response):
                self.imageInfos = response.backdrops ?? []
                if self.mediaType == .image {
                    self.mediaListAdapter.performUpdates(animated: true, completion: nil)
                }
            case .failure(let error):
                Log.d(error)
            }
        }
        
        // 관련 비디오
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
    }
    
    func changeMediaType(_ type: MediaType) {
        mediaType = type
        self.mediaListAdapter.performUpdates(animated: true, completion: nil)
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ContentsDetailViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        switch listAdapter {
        case mediaTypeAdapter:
            return MediaType.allCases.map { $0.title as ListDiffable }
        case mediaListAdapter:
            switch mediaType {
            case .image:
                return imageInfos
            case .video:
                return videoInfos
            }
        case creditAdapter:
            return credits
        default:
            return []
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch listAdapter {
        case mediaTypeAdapter:
            let section = TextTabSectionController()
            section.delegate = self
            return section
        case mediaListAdapter:
            return MediaSectionController(mediaType: mediaType)
        case creditAdapter:
            return CreditSectionController()
        default:
            return ListSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension ContentsDetailViewController: TextTabDelegate {
    func didSelectTab(index: Int) {
        if let type = MediaType(rawValue: index) {
            changeMediaType(type)
        }
    }
}
