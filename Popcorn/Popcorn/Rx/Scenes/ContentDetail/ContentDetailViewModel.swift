//
//  ContentDetailViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/01.
//

import Foundation
import RxSwift

class ContentDetailViewModel: ViewModel {
    typealias DetailSectionItem = _SectionItem<DetailSection, RowViewModel>
    
    struct Input {
        let ready: Observable<Void>
        let localizeChanged: Observable<Void>
        let headerSelection: Observable<Int>
        let selection: Observable<RowViewModel>
    }
    
    struct Output {
        let posterImage: Observable<UIImage>
        let sectionItems: Observable<[DetailSectionItem]>
        let selectedContent: Observable<_Content>
        let selectedSection: Observable<([RowViewModel], DetailSection)>
    }
    
    var content: _Content
    var heroID: String?
    let coordinator: ContentDetailCoordinator
    
    init(with content: _Content, heroID: String?, networkService: TmdbService = TmdbAPI(), coordinator: ContentDetailCoordinator) {
        self.content = content
        self.heroID = heroID
        self.coordinator = coordinator
        
        super.init(networkService: networkService)
    }
    
    func transform(input: Input) -> Output {
        let posterImage = input.ready
            .map { [weak self] in
                guard let self = self else { return nil }
                return self.content.posterPath
            }
            .compactMap { $0 }
            .flatMap {
                ImagePipeline.shared.rx.loadImage(with: AppConstants.Domain.tmdbImage + $0)
            }
            .map { $0.image }
        
        let sectionItems: Observable<[DetailSectionItem]>
        let updateTrigger = Observable.merge(input.ready, input.localizeChanged)

        switch content {
        case let movie as _Movie:
            sectionItems = updateTrigger
                .map{ movie.id }
                .flatMap { [weak self] id -> Observable<(_Movie, [Person], [VideoInfo], [ImageInfo], [_Movie], [_Movie], [Review])> in
                    guard let self = self else { return Observable.empty() }
                    
                    return Observable.zip(
                        self.networkService.movieDetails(id: id)
                            .trackActivity(self.activityIndicator)
                            .trackError(self.errorTracker),
                        self.networkService.movieCredits(id: id)
                            .trackActivity(self.activityIndicator)
                            .trackError(self.errorTracker),
                        self.networkService.movieVideos(id: id)
                            .trackActivity(self.activityIndicator)
                            .trackError(self.errorTracker),
                        self.networkService.movieImages(id: id)
                            .trackActivity(self.activityIndicator)
                            .trackError(self.errorTracker),
                        self.networkService.movieRecommendations(id: id, page: 1)
                            .trackActivity(self.activityIndicator)
                            .trackError(self.errorTracker),
                        self.networkService.movieSimilar(id: id, page: 1)
                            .trackActivity(self.activityIndicator)
                            .trackError(self.errorTracker),
                        self.networkService.movieReviews(id: id, page: 1)
                            .trackActivity(self.activityIndicator)
                            .trackError(self.errorTracker))
                }
                .map { (movie, credits, videos, imageInfos, recommendations, similar, reviews) -> [DetailSectionItem] in
                    var sectionItems: [DetailSectionItem] = [
                        DetailSectionItem(section: .movie(.title),
                                          items: [TitleItemViewModel(with: movie)])
                    ]
                    
                    var synopsisViewModels: [SynopsisItemViewModel] = []
                    if let tagline = movie.tagline, tagline.count > 0 {
                        synopsisViewModels.append(SynopsisItemViewModel(with: tagline, isTagline: true))
                    }
                    if let overview = movie.overview, overview.count > 0 {
                        synopsisViewModels.append(SynopsisItemViewModel(with: overview, isTagline: false))
                    }
                    if !synopsisViewModels.isEmpty {
                        sectionItems.append(DetailSectionItem(section: .movie(.synopsis),
                                                              items: synopsisViewModels))
                    }
                    
                    if credits.count > 0 {
                        sectionItems.append(DetailSectionItem(section: .movie(.credit),
                                                              items: credits.map { CreditItemViewModel(with: $0) }))
                    }
                    
                    if movie.reports.count > 0 {
                        sectionItems.append(DetailSectionItem(section: .movie(.report),
                                                              items: movie.reports.map { ReportItemViewModel(with: $0) }))
                    }
                    
                    if videos.count > 0 {
                        sectionItems.append(DetailSectionItem(section: .movie(.video),
                                                              items: videos.map { VideoItemViewModel(with: $0) }))
                    }
                    
                    if imageInfos.count > 0 {
                        sectionItems.append(DetailSectionItem(section: .movie(.image),
                                                              items: imageInfos.map { ImageItemViewModel(with: $0) }))
                    }
                    
                    if recommendations.count > 0 {
                        sectionItems.append(DetailSectionItem(section: .movie(.recommendation),
                                                              items: recommendations.map { PosterItemViewModel(with: $0, heroID: "recommendations_\($0.id)") }))
                    }
                    
                    if similar.count > 0 {
                        sectionItems.append(DetailSectionItem(section: .movie(.similar),
                                                              items: similar.map { PosterItemViewModel(with: $0, heroID: "similar_\($0.id)") }))
                    }
                    
                    if reviews.count > 0 {
                        sectionItems.append(DetailSectionItem(section: .movie(.review),
                                                              items: reviews.map { ReviewItemViewModel(with: $0) }))
                    }
                    
                    return sectionItems
                }

        case let tvShow as _TVShow:
            sectionItems = updateTrigger
                .map{ tvShow.id }
                .flatMap { [weak self] id -> Observable<(_TVShow, [Person], [VideoInfo], [ImageInfo], [_TVShow], [_TVShow], [Review])> in
                    guard let self = self else { return Observable.empty() }
                    
                    return Observable.zip(
                        self.networkService.tvShowDetails(id: id)
                            .trackActivity(self.activityIndicator)
                            .trackError(self.errorTracker),
                        self.networkService.tvShowCredits(id: id)
                            .trackActivity(self.activityIndicator)
                            .trackError(self.errorTracker),
                        self.networkService.tvShowVideos(id: id)
                            .trackActivity(self.activityIndicator)
                            .trackError(self.errorTracker),
                        self.networkService.tvShowImages(id: id)
                            .trackActivity(self.activityIndicator)
                            .trackError(self.errorTracker),
                        self.networkService.tvShowRecommendations(id: id, page: 1)
                            .trackActivity(self.activityIndicator)
                            .trackError(self.errorTracker),
                        self.networkService.tvShowSimilar(id: id, page: 1)
                            .trackActivity(self.activityIndicator)
                            .trackError(self.errorTracker),
                        self.networkService.tvShowReviews(id: id, page: 1)
                            .trackActivity(self.activityIndicator)
                            .trackError(self.errorTracker))
                }
                .map { (tvShow, credits, videos, imageInfos, recommendations, similar, reviews) -> [DetailSectionItem] in
                    var sectionItems: [DetailSectionItem] = [
                        DetailSectionItem(section: .tvShow(.title),
                                          items: [TitleItemViewModel(with: tvShow)])
                    ]
                    
                    var synopsisViewModels: [SynopsisItemViewModel] = []
                    if let tagline = tvShow.tagline, tagline.count > 0 {
                        synopsisViewModels.append(SynopsisItemViewModel(with: tagline, isTagline: true))
                    }
                    if let overview = tvShow.overview, overview.count > 0 {
                        synopsisViewModels.append(SynopsisItemViewModel(with: overview, isTagline: false))
                    }
                    if !synopsisViewModels.isEmpty {
                        sectionItems.append(DetailSectionItem(section: .tvShow(.synopsis),
                                                              items: synopsisViewModels))
                    }
                    
                    if credits.count > 0 {
                        sectionItems.append(DetailSectionItem(section: .tvShow(.credit),
                                                              items: credits.map { CreditItemViewModel(with: $0) }))
                    }
                    
                    if tvShow.reports.count > 0 {
                        sectionItems.append(DetailSectionItem(section: .tvShow(.report),
                                                              items: tvShow.reports.map { ReportItemViewModel(with: $0) }))
                    }
                    
                    if videos.count > 0 {
                        sectionItems.append(DetailSectionItem(section: .tvShow(.video),
                                                              items: videos.map { VideoItemViewModel(with: $0) }))
                    }
                    
                    if imageInfos.count > 0 {
                        sectionItems.append(DetailSectionItem(section: .tvShow(.image),
                                                              items: imageInfos.map { ImageItemViewModel(with: $0) }))
                    }
                    
                    if recommendations.count > 0 {
                        sectionItems.append(DetailSectionItem(section: .tvShow(.recommendation),
                                                              items: recommendations.map { PosterItemViewModel(with: $0, heroID: "recommendations_\($0.id)") }))
                    }
                    
                    if similar.count > 0 {
                        sectionItems.append(DetailSectionItem(section: .tvShow(.similar),
                                                              items: similar.map { PosterItemViewModel(with: $0, heroID: "similar_\($0.id)") }))
                    }
                    
                    if reviews.count > 0 {
                        sectionItems.append(DetailSectionItem(section: .tvShow(.review),
                                                              items: reviews.map { ReviewItemViewModel(with: $0) }))
                    }
                    
                    return sectionItems
                }
        default:
            sectionItems = Observable.empty()
        }
        
        // 셀 선택 - 디테일 화면 이동
        let selectedContent = input.selection
            .compactMap { $0 as? PosterItemViewModel }
            .map { ($0.content, $0.posterHeroId) }
            .do(onNext: coordinator.showDetail)
            .map{ $0.0 }
        
        // 헤더 선택 - 차트 리스트 화면 이동
        let selectedSection = input.headerSelection
            .withLatestFrom(sectionItems) { section, result in
                return (result[section].items.map { $0 }, result[section].section)
            }
            .do(onNext: { [weak self] (viewModels, section) in
                guard let self = self else { return }
                
                switch viewModels {
                case let (posterItemViewModels as [PosterItemViewModel]) as Any:
                    let contents = posterItemViewModels.map { $0.content }
                    self.coordinator.showContentsList(contents: contents, section: section)
                default:
                    break
                }
            })
//            .do(onNext: coordinator.showContentsList)
        
        return Output(posterImage: posterImage, sectionItems: sectionItems, selectedContent: selectedContent, selectedSection: selectedSection)
    }
    
//    func requestInfo(for sections: [SectionType]) {
//        for (index, section) in sections.enumerated() {
//            switch section {
//            case let movieSection as Section.Detail.Movie:
//                switch movieSection {
//                case .title:
//                    // 영화 상세 정보
//                    APIManager.request(AppConstants.API.Movie.getDetails(contents.id), method: .get, params: nil, responseType: Movie.self) { (result) in
//                        switch result {
//                        case .success(let contents):
//                            self.contents = contents
//                            self.updateSectionItems([contents], at: index)
//                            self.updateSectionItems(contents.detailInfos, at: Section.Detail.Movie.detail.rawValue)
//
//                            // 시놉시스 (tagline + overview)
//                            var synopsisInfo: [ListDiffable] = []
//                            if let tagline = contents.tagline, !tagline.isEmpty {
//                                synopsisInfo.append((tagline + "\n") as ListDiffable)
//                            }
//
//                            if let overview = contents.overview, !overview.isEmpty {
//                                synopsisInfo.append(overview as ListDiffable)
//                            }
//
//                            self.updateSectionItems(synopsisInfo, at: Section.Detail.Movie.synopsis.rawValue)
//                        case .failure(let error):
//                            Log.d(error)
//                        }
//                    }
//                case .synopsis:
//                    break
//                case .credit:
//                    // 출연, 감독
//                    APIManager.request(AppConstants.API.Movie.getCredits(contents.id), method: .get, params: nil, responseType: ListResponse.self) { (result) in
//                        switch result {
//                        case .success(let response):
//                            var credits: [Person] = response.cast ?? []
//                            // 감독을 맨 앞에 삽입
//                            if let director = response.crew?.filter({ $0.job == "Director" }).first {
//                                credits.insert(director, at: 0)
//                            }
//
//                            self.updateSectionItems(credits, at: index)
//                        case .failure(let error):
//                            Log.d(error)
//                        }
//                    }
//                case .detail:
//                    break
//                case .image:
//                    // 관련 이미지(배경,포스터)
//                    APIManager.request(AppConstants.API.Movie.getImages(contents.id), method: .get, params: nil, Localization: false, responseType: ListResponse.self) { (result) in
//                        switch result {
//                        case .success(let response):
//                            let backdrops = response.backdrops ?? []
//                            let posters = response.posters ?? []
//
//                            backdrops.forEach { $0.type = .backdrop }
//                            posters.forEach { $0.type = .poster }
//
//                            let imageInfos = backdrops + posters
//                            self.updateSectionItems(imageInfos, at: index)
//                        case .failure(let error):
//                            Log.d(error)
//                        }
//                    }
//                case .video:
//                    // 관련 비디오(유튜브)
//                    APIManager.request(AppConstants.API.Movie.getVideos(contents.id), method: .get, params: nil, responseType: Response<VideoInfo>.self) { (result) in
//                        switch result {
//                        case .success(let response):
//                            let videoInfos = response.results ?? []
//                            self.updateSectionItems(videoInfos, at: index)
//                        case .failure(let error):
//                            Log.d(error)
//                        }
//                    }
//                case .review:
//                    // 리뷰목록
//                    APIManager.request(AppConstants.API.Movie.getReviews(contents.id), method: .get, params: nil, Localization: false, responseType: PageResponse<Review>.self) { (result) in
//                        switch result {
//                        case .success(let response):
//                            let reviews = response.results ?? []
//                            self.updateSectionItems(reviews, at: index)
//                        case .failure(let error):
//                            Log.d(error)
//                        }
//                    }
//                case .recommendation:
//                    // 추천목록
//                    APIManager.request(AppConstants.API.Movie.getRecommendations(contents.id), method: .get, params: nil, responseType: PageResponse<Movie>.self) { (result) in
//                        switch result {
//                        case .success(let response):
//                            let recommendations = response.results ?? []
//                            self.updateSectionItems(recommendations, at: index)
//                        case .failure(let error):
//                            Log.d(error)
//                        }
//                    }
//                case .similar:
//                    // 비슷한목록
//                    APIManager.request(AppConstants.API.Movie.getSimilar(contents.id), method: .get, params: nil, responseType: PageResponse<Movie>.self) { (result) in
//                        switch result {
//                        case .success(let response):
//                            let similars = response.results ?? []
//                            self.updateSectionItems(similars, at: index)
//                        case .failure(let error):
//                            Log.d(error)
//                        }
//                    }
//                }
//            case let tvShowSection as Section.Detail.TVShow:
//                switch tvShowSection {
//                case .title:
//                    // 영화 상세 정보
//                    APIManager.request(AppConstants.API.TVShow.getDetails(contents.id), method: .get, params: nil, responseType: TVShow.self) { (result) in
//                        switch result {
//                        case .success(let contents):
//                            self.contents = contents
//                            self.updateSectionItems([contents], at: index)
//                            self.updateSectionItems(contents.detailInfos, at: Section.Detail.Movie.detail.rawValue)
//
//                            // 시놉시스 (tagline + overview)
//                            var synopsisInfo: [ListDiffable] = []
//                            if let tagline = contents.tagline, !tagline.isEmpty {
//                                synopsisInfo.append((tagline + "\n") as ListDiffable)
//                            }
//
//                            if let overview = contents.overview, !overview.isEmpty {
//                                synopsisInfo.append(overview as ListDiffable)
//                            }
//
//                            self.updateSectionItems(synopsisInfo, at: Section.Detail.Movie.synopsis.rawValue)
//                        case .failure(let error):
//                            Log.d(error)
//                        }
//                    }
//                case .synopsis:
//                    break
//                case .credit:
//                    // 출연, 감독
//                    APIManager.request(AppConstants.API.TVShow.getCredits(contents.id), method: .get, params: nil, responseType: ListResponse.self) { (result) in
//                        switch result {
//                        case .success(let response):
//                            var credits: [Person] = response.cast ?? []
//                            // 감독을 맨 앞에 삽입
//                            if let director = response.crew?.filter({ $0.job == "Director" }).first {
//                                credits.insert(director, at: 0)
//                            }
//
//                            self.updateSectionItems(credits, at: index)
//                        case .failure(let error):
//                            Log.d(error)
//                        }
//                    }
//                case .detail:
//                    break
//                case .season:
//                    // TODO: 시즌 추가
//                    break
//                case .episodeGroup:
//                    // TODO: 에피소드 그룹 추가
//                    break
//                case .image:
//                    // 관련 이미지(배경,포스터)
//                    APIManager.request(AppConstants.API.TVShow.getImages(contents.id), method: .get, params: nil, Localization: false, responseType: ListResponse.self) { (result) in
//                        switch result {
//                        case .success(let response):
//                            let backdrops = response.backdrops ?? []
//                            let posters = response.posters ?? []
//
//                            backdrops.forEach { $0.type = .backdrop }
//                            posters.forEach { $0.type = .poster }
//
//                            let imageInfos = backdrops + posters
//                            self.updateSectionItems(imageInfos, at: index)
//                        case .failure(let error):
//                            Log.d(error)
//                        }
//                    }
//                case .video:
//                    // 관련 비디오(유튜브)
//                    APIManager.request(AppConstants.API.TVShow.getVideos(contents.id), method: .get, params: nil, responseType: Response<VideoInfo>.self) { (result) in
//                        switch result {
//                        case .success(let response):
//                            let videoInfos = response.results ?? []
//                            self.updateSectionItems(videoInfos, at: index)
//                        case .failure(let error):
//                            Log.d(error)
//                        }
//                    }
//                case .review:
//                    // 리뷰목록
//                    APIManager.request(AppConstants.API.TVShow.getReviews(contents.id), method: .get, params: nil, Localization: false, responseType: PageResponse<Review>.self) { (result) in
//                        switch result {
//                        case .success(let response):
//                            let reviews = response.results ?? []
//                            self.updateSectionItems(reviews, at: index)
//                        case .failure(let error):
//                            Log.d(error)
//                        }
//                    }
//                case .recommendation:
//                    // 추천목록
//                    APIManager.request(AppConstants.API.TVShow.getRecommendations(contents.id), method: .get, params: nil, responseType: PageResponse<TVShow>.self) { (result) in
//                        switch result {
//                        case .success(let response):
//                            let recommendations = response.results ?? []
//                            self.updateSectionItems(recommendations, at: index)
//                        case .failure(let error):
//                            Log.d(error)
//                        }
//                    }
//                case .similar:
//                    // 비슷한목록
//                    APIManager.request(AppConstants.API.TVShow.getSimilar(contents.id), method: .get, params: nil, responseType: PageResponse<TVShow>.self) { (result) in
//                        switch result {
//                        case .success(let response):
//                            let similars = response.results ?? []
//                            self.updateSectionItems(similars, at: index)
//                        case .failure(let error):
//                            Log.d(error)
//                        }
//                    }
//                }
//            default:
//                return
//            }
//        }
//    }
}
