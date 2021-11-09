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
        let actionSelection: Observable<ContentAction>
        let shareSelection: Observable<Void>
        let selection: Observable<RowViewModel>
    }
    
    struct Output {
        let posterImage: Observable<UIImage>
        let sectionItems: Observable<[DetailSectionItem]>
        let selectedContent: Observable<_Content>
        let selectedSection: Observable<([RowViewModel], DetailSection)>
        let selectedAction: Observable<Void>
        let selectedShare: Observable<Void>
        let accountStates: Observable<AccountStates>
    }
    
    var content: _Content
    var heroID: String?
    let coordinator: ContentDetailCoordinator
    let accountStates = BehaviorSubject<AccountStates>(value: AccountStates())
    
    init(with content: _Content, heroID: String?, networkService: TmdbService = TmdbAPI(), coordinator: ContentDetailCoordinator) {
        self.content = content
        self.heroID = heroID
        self.coordinator = coordinator
        
        super.init(networkService: networkService)
    }
    
    func transform(input: Input) -> Output {
        let posterImageSubject = BehaviorSubject<UIImage?>(value: nil)
        
        let posterImage = input.ready
            .compactMap { [weak self] in
                guard let self = self else { return nil }
                return self.content.posterPath
            }
            .flatMap {
                ImagePipeline.shared.rx.loadImage(with: AppConstants.Domain.tmdbImage + $0)
            }
            .map { $0.image }
            .do(onNext: { posterImageSubject.onNext($0) })
        
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
                                          items: [TitleItemViewModel(with: movie, state: self.accountStates.asObservable())])
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
                                          items: [TitleItemViewModel(with: tvShow, state: self.accountStates.asObservable())])
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
                    self.coordinator.showList(contents: contents, section: section)
                case let (creditItemViewModels as [CreditItemViewModel]) as Any:
                    let credits = creditItemViewModels.map { $0.person }
                    self.coordinator.showList(credits: credits, section: section)
                default:
                    break
                }
            })
                
        // 액션 선택 - 팝업 띄움
        let selectedAction = input.actionSelection
            .withLatestFrom(accountStates){ ($0, $1) }
            .flatMap{ [weak self] action, states -> Observable<Void> in
                guard let self = self else { return Observable.empty() }

                let sessionID = AuthManager.shared.auth?.sessionID
                let accountID = AuthManager.shared.auth?.accountID
                let type = self.content.contentType
                let id = self.content.id
                
                switch (action, sessionID, accountID) {
                case let (.rate, sessionID?, accountID?):
                    return Observable.empty()
                case let (.favorite, sessionID?, accountID?):
                    let isFavorite = states.favorite ?? false
                    return self.networkService.markFavorite(accountID: accountID,
                                                            sessionID: sessionID,
                                                            type: type,
                                                            id: id,
                                                            add: !isFavorite)
                case let (.watchlist, sessionID?, accountID?):
                    let isWatchlist = states.watchlist ?? false
                    return self.networkService.markWatchlist(accountID: accountID,
                                                             sessionID: sessionID,
                                                             type: type,
                                                             id: id,
                                                             add: !isWatchlist)
                default:
                    return Observable.empty()
                }
            }
            .share()
        
        let selectedShare = input.shareSelection
            .do(onNext: { [weak self] in
                guard let self = self else { return }
                var activityItems: [Any] = []
                
                if let image = try? posterImageSubject.value() {
                    activityItems.append(image)
                }
                
                if let title = self.content.title {
                    activityItems.append(title)
                }
                
                if let originalTitle = self.content.originalTitle, originalTitle != self.content.title {
                    activityItems.append("(\(originalTitle))")
                }
                
                self.coordinator.showRatePopup(activityItems: activityItems)
            })
            .mapToVoid()
        
        Observable.merge(input.ready, selectedAction)
            .flatMap { [weak self] () -> Observable<AccountStates> in
                guard let self = self, let sessionID = AuthManager.shared.auth?.sessionID else { return Observable.empty() }

                return self.networkService.accountStates(sessionID: sessionID,
                                                         type: self.content.contentType,
                                                         id: self.content.id)
                    .trackActivity(self.activityIndicator)
                    .trackError(self.errorTracker)
            }
            .subscribe(onNext: accountStates.onNext(_:))
            .disposed(by: disposeBag)
        
        
        return Output(posterImage: posterImage, sectionItems: sectionItems, selectedContent: selectedContent, selectedSection: selectedSection, selectedAction: selectedAction, selectedShare: selectedShare, accountStates: accountStates)
    }
}
