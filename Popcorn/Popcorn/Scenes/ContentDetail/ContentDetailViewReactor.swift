//
//  ContentDetailViewReactor.swift
//  Popcorn
//
//  Created by Front-Artist on 2022/01/03.
//

import ReactorKit
import RxSwift

final class ContentDetailViewReactor: Reactor {
    typealias DetailSectionItem = SectionItem<DetailSection, RowViewModel>

    enum Action {
        case load
        case appear
        case localizeChanged
        case markFavorite
        case markWatchList
        case selectHeader(Int)
        case selectItem(RowViewModel)
    }
    
    enum Mutation {
        case setPosterImageURL(String?)
        case setLoading(Bool)
        case setTitle(Content, AccountStates)
        case setSynopsis(String?, String?)
        case setReports([Report])
        case setCredits([Person])
        case setVideos([VideoInfo])
        case setImages([ImageInfo])
        case setRecommendations([Content])
        case setSimilar([Content])
        case setReviews([Review])
        case setFavorite(Bool)
        case setWatchList(Bool)
        case setAccountStates(AccountStates)
    }
    
    struct State {
        var posterImageURL: URL?
        var sectionItems: [DetailSectionItem] = []
        var accountStates: AccountStates = AccountStates()
        var isLoading: Bool = false
    }
    
    private var content: Content
    private var heroID: String?
    private let coordinator: ContentDetailCoordinator
    private let networkService: TmdbService
    private let activityIndicator = ActivityIndicator()

    var initialState: State = State()
    
    init(with content: Content, heroID: String?, networkService: TmdbService = TmdbAPI(), coordinator: ContentDetailCoordinator) {
        self.content = content
        self.heroID = heroID
        self.coordinator = coordinator
        self.networkService = networkService
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        let id = content.id
        let type = content.contentType
        let sessionID = AuthManager.shared.auth?.sessionID
        
        switch action {
        case .load:
            let details: Observable<Mutation>
            switch type {
            case .movies:
                details = Observable.merge(
                    Observable.zip(
                        networkService.movieDetails(id: id),
                        networkService.accountStates(sessionID: sessionID,
                                                     type: type,
                                                     id: id)
                    )
                        .trackActivity(activityIndicator)
                        .flatMap { (movie, states) in
                            Observable.of(Mutation.setTitle(movie, states),
                                          Mutation.setSynopsis(movie.tagline, movie.overview),
                                          Mutation.setReports(movie.reports),
                                          Mutation.setAccountStates(states))
                        },
                    networkService.movieCredits(id: id)
                        .trackActivity(activityIndicator)
                        .map { Mutation.setCredits($0) },
                    networkService.movieVideos(id: id)
                        .trackActivity(activityIndicator)
                        .map { Mutation.setVideos($0) },
                    networkService.movieImages(id: id)
                        .trackActivity(activityIndicator)
                        .map { Mutation.setImages($0) },
                    networkService.movieRecommendations(id: id, page: 1)
                        .trackActivity(activityIndicator)
                        .mapToResults()
                        .map { Mutation.setRecommendations($0) },
                    networkService.movieSimilar(id: id, page: 1)
                        .trackActivity(activityIndicator)
                        .mapToResults()
                        .map { Mutation.setSimilar($0) },
                    networkService.movieReviews(id: id, page: 1)
                        .trackActivity(activityIndicator)
                        .mapToResults()
                        .map { Mutation.setReviews($0) }
                )
            case .tvShows:
                details = Observable.merge(
                    Observable.zip(
                        networkService.tvShowDetails(id: id),
                        networkService.accountStates(sessionID: sessionID,
                                                     type: .tvShows,
                                                     id: id)
                    )
                        .trackActivity(activityIndicator)
                        .flatMap { (tv, states) in
                            Observable.of(Mutation.setTitle(tv, states),
                                          Mutation.setSynopsis(tv.tagline, tv.overview),
                                          Mutation.setReports(tv.reports),
                                          Mutation.setAccountStates(states))
                        },
                    networkService.tvShowCredits(id: id)
                        .trackActivity(activityIndicator)
                        .map { Mutation.setCredits($0) },
                    networkService.tvShowVideos(id: id)
                        .trackActivity(activityIndicator)
                        .map { Mutation.setVideos($0) },
                    networkService.tvShowImages(id: id)
                        .trackActivity(activityIndicator)
                        .map { Mutation.setImages($0) },
                    networkService.tvShowRecommendations(id: id, page: 1)
                        .trackActivity(activityIndicator)
                        .mapToResults()
                        .map { Mutation.setRecommendations($0) },
                    networkService.tvShowSimilar(id: id, page: 1)
                        .trackActivity(activityIndicator)
                        .mapToResults()
                        .map { Mutation.setSimilar($0) },
                    networkService.tvShowReviews(id: id, page: 1)
                        .trackActivity(activityIndicator)
                        .mapToResults()
                        .map { Mutation.setReviews($0) }
                )
            }
            
            return Observable.merge(
                .just(Mutation.setPosterImageURL(content.posterPath)),
                activityIndicator.asObservable()
                    .map { Mutation.setLoading($0) },
                details
            )
        case .appear:
            return .empty()
        case .localizeChanged:
            return .empty()
        case .selectHeader(let index):
            let section = currentState.sectionItems[index].section
            coordinator.showList(section: section)
            
            return .empty()
        case .markFavorite:
            guard let auth = AuthManager.shared.auth,
                  let sessionID = auth.sessionID,
                  let accountID = auth.accountID else {
                      return .empty()
                  }
            
            let add = !currentState.accountStates.favorite
            
            return networkService.markFavorite(accountID: accountID,
                                               sessionID: sessionID,
                                               type: content.contentType,
                                               id: content.id,
                                               add: add)
                .map { _ in Mutation.setFavorite(add) }
        case .markWatchList:
            guard let auth = AuthManager.shared.auth,
                  let sessionID = auth.sessionID,
                  let accountID = auth.accountID else {
                      return .empty()
                  }
            
            let add = !currentState.accountStates.watchlist
            
            return networkService.markWatchlist(accountID: accountID,
                                                sessionID: sessionID,
                                                type: content.contentType,
                                                id: content.id,
                                                add: add)
                .map { _ in Mutation.setWatchList(add) }
        case .selectItem(let viewModel):
            if let viewModel = viewModel as? PosterItemViewModel {
                coordinator.showDetail(content: viewModel.content,
                                       heroID: viewModel.posterHeroId)
            }
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setPosterImageURL(let url?):
            if let url = URL(string: AppConstants.Domain.tmdbImage + url) {
                newState.posterImageURL = url
            }
            
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
            
        case .setTitle(let content, let states):
            let item = DetailSectionItem(section: .title,
                                         items: [TitleCellReactor(with: content, rated: states.rated, coordinator: coordinator)])
            updatedSectionItems(&newState.sectionItems, with: item)
            
        case .setSynopsis(let tagline, let overview):
            var synopsisViewModels: [SynopsisItemViewModel] = []
            if let tagline = tagline, tagline.count > 0 {
                synopsisViewModels.append(SynopsisItemViewModel(with: tagline, isTagline: true))
            }
            if let overview = overview, overview.count > 0 {
                synopsisViewModels.append(SynopsisItemViewModel(with: overview, isTagline: false))
            }
            
            if !synopsisViewModels.isEmpty {
                let item = DetailSectionItem(section: .synopsis,
                                             items: synopsisViewModels)
                
                updatedSectionItems(&newState.sectionItems, with: item)
            }
            
        case .setReports(let reports) where reports.count > 0:
            let item = DetailSectionItem(section: .report,
                                         items: reports.map { ReportItemViewModel(with: $0) })
            updatedSectionItems(&newState.sectionItems, with: item)
            
        case .setCredits(let credits) where credits.count > 0:
            let item = DetailSectionItem(section: .credit,
                                         items: credits.map { CreditItemViewModel(with: $0) })
            updatedSectionItems(&newState.sectionItems, with: item)
            
        case .setVideos(let videos) where videos.count > 0:
            let item = DetailSectionItem(section: .video,
                                         items: videos.map { VideoItemViewModel(with: $0) })
            updatedSectionItems(&newState.sectionItems, with: item)
            
        case .setImages(let images) where images.count > 0:
            let item = DetailSectionItem(section: .image,
                                         items: images.map { ImageItemViewModel(with: $0) })
            updatedSectionItems(&newState.sectionItems, with: item)
            
        case .setRecommendations(let contents) where contents.count > 0:
            let item = DetailSectionItem(section: .recommendation,
                                         items: contents.map { PosterItemViewModel(with: $0, heroID: "recommendations_\($0.id)") })
            updatedSectionItems(&newState.sectionItems, with: item)
            
        case .setSimilar(let contents) where contents.count > 0:
            let item = DetailSectionItem(section: .similar,
                                         items: contents.map { PosterItemViewModel(with: $0, heroID: "similar_\($0.id)") })
            updatedSectionItems(&newState.sectionItems, with: item)
            
        case .setReviews(let reviews) where reviews.count > 0:
            let item = DetailSectionItem(section: .review,
                                         items: reviews.map { ReviewItemViewModel(with: $0) })
            updatedSectionItems(&newState.sectionItems, with: item)
            
        case .setFavorite(let isFavorite):
            newState.accountStates.favorite = isFavorite
            
        case .setWatchList(let isWatchList):
            newState.accountStates.watchlist = isWatchList
                
        case .setAccountStates(let states):
            newState.accountStates = states
            
            let item = DetailSectionItem(section: .title,
                                         items: [TitleCellReactor(with: content, rated: states.rated, coordinator: coordinator)])
            updatedSectionItems(&newState.sectionItems, with: item)
        default:
            break
        }
        
        return newState
    }
    
    private func updatedSectionItems(_ sectionItems: inout [DetailSectionItem], with sectionItem: DetailSectionItem) {
        if let index = sectionItems.firstIndex(where: { $0.section == sectionItem.section }) {
            sectionItems[index].items = sectionItem.items
        } else {
            sectionItems.append(sectionItem)
            sectionItems.sort(by: { $0.section.rawValue < $1.section.rawValue })
        }
    }
}
