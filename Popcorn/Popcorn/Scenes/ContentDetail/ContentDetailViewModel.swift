//
//  ContentDetailViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/01.
//

import Foundation
import RxSwift
import RxCocoa

class ContentDetailViewModel: ViewModelType {
    typealias DetailSectionItem = _SectionItem<DetailSection, RowViewModel>
    
    struct Input {
        let ready: Driver<Void>
    }
    
    struct Output {
        let sectionItems: Driver<[DetailSectionItem]>
    }
    
    var content: _Content
    let networkService: TmdbService
    let coordinator: ContentDetailCoordinator
    
    init(with content: _Content, networkService: TmdbService = TmdbAPI(), coordinator: ContentDetailCoordinator) {
        self.content = content
        self.networkService = networkService
        self.coordinator = coordinator
    }
    
    func transform(input: Input) -> Output {
        let sectionItems: Driver<[DetailSectionItem]>
        
        switch content {
        case let movie as _Movie:
            sectionItems = input.ready.asObservable()
                .debug()
                .map{ movie.id }
                .flatMap {
                    return Observable.zip(
                        self.networkService.movieDetails(id: $0),
                        self.networkService.movieCredits(id: $0),
                        self.networkService.movieVideos(id: $0),
                        self.networkService.movieImages(id: $0),
                        self.networkService.movieRecommendations(id: $0, page: 1),
                        self.networkService.movieSimilar(id: $0, page: 1),
                        self.networkService.movieReviews(id: $0, page: 1))
                }
                .map { (movie, credits, videos, imageSet, recommendations, similar, reviews) -> [DetailSectionItem] in
                    return [
                        DetailSectionItem(section: .movie(.title), items: [TitleCellViewModel(with: movie)]),
//                        DetailSectionItem(section: .movie(.credit), items: [TitleCellViewModel(with: movie)]),
//                        DetailSectionItem(section: .movie(.video), items: [TitleCellViewModel(with: movie)]),
//                        DetailSectionItem(section: .movie(.image), items: [TitleCellViewModel(with: movie)]),
//                        DetailSectionItem(section: .movie(.recommendation), items: [TitleCellViewModel(with: movie)]),
//                        DetailSectionItem(section: .movie(.similar), items: [TitleCellViewModel(with: movie)]),
//                        DetailSectionItem(section: .movie(.review), items: [TitleCellViewModel(with: movie)])
                    ]
                }
                .asDriver(onErrorJustReturn: [])
        case let tvShow as _TVShow:
            sectionItems = input.ready.asObservable()
                .debug()
                .map{ tvShow.id }
                .flatMap {
                    return Observable.zip(
                        self.networkService.tvShowDetails(id: $0),
                        self.networkService.tvShowCredits(id: $0),
                        self.networkService.tvShowVideos(id: $0),
                        self.networkService.tvShowImages(id: $0),
                        self.networkService.tvShowRecommendations(id: $0, page: 1),
                        self.networkService.tvShowSimilar(id: $0, page: 1),
                        self.networkService.tvShowReviews(id: $0, page: 1))
                }
                .map { (tvShow, credits, videos, imageSet, recommendations, similar, reviews) -> [DetailSectionItem] in
                    return [DetailSectionItem(section: .tvShow(.title), items: [TitleCellViewModel(with: tvShow)]) ]
                }
                .asDriver(onErrorJustReturn: [])
        default:
            sectionItems = Driver.empty()
        }
                    
        return Output(sectionItems: sectionItems)
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
