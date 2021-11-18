//
//  TmdbAPI.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/26.
//

import Foundation
import RxSwift
import Moya

final class TmdbAPI {
//    lazy var provider = MoyaProvider<TmdbTarget>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    lazy var provider = MoyaProvider<TmdbTarget>()

    private var language: Language
    private var region: Country
    
    init(language: Language = Localize.currentLanguage, region: Country = Localize.currentRegion) {
        self.language = language
        self.region = region
    }
}

// MARK: - TmdbMovieService
extension TmdbAPI: TmdbMovieService {
    func movies(chart: MovieChart, page: Int) -> Observable<PageResponse<Movie>> {
        return provider.rx
            .request(.movies(chart: chart, page: page, language: language, region: region))
            .retry(3)
            .map(PageResponse<Movie>.self)
            .asObservable()
    }
    
    func movieDetails(id: Int) -> Observable<Movie> {
        return provider.rx
            .request(.details(type: .movies, id: id, language: language))
            .retry(3)
            .map(Movie.self)
            .asObservable()
    }
    
    func movieCredits(id: Int) -> Observable<[Person]> {
        return provider.rx
            .request(.credits(type: .movies, id: id, language: language))
            .retry(3)
            .map(ListResponse.self)
            .map{
                var credits: [Person] = $0.cast ?? []
                
                if let director = $0.crew?.filter({ $0.job == "Director" }).first {
                    credits.insert(director, at: 0)
                }
                
                return credits
            }
            .asObservable()
    }
    
    func movieVideos(id: Int) -> Observable<[VideoInfo]> {
        return provider.rx
            .request(.videos(type: .movies, id: id, language: .init(code: .en)))
            .retry(3)
            .map(Response<VideoInfo>.self)
            .map{ $0.results ?? [] }
            .asObservable()
    }

    
    func movieImages(id: Int) -> Observable<[ImageInfo]> {
        return provider.rx
            .request(.images(type: .movies, id: id, language: .init(code: .en)))
            .retry(3)
            .map(ListResponse.self)
            .map{ ($0.backdrops ?? []) + ($0.posters ?? []) }
            .asObservable()
    }
    
    func movieRecommendations(id: Int, page: Int) -> Observable<PageResponse<Movie>> {
        return provider.rx
            .request(.recommendations(type: .movies, id: id, page: page, language: language))
            .retry(3)
            .map(PageResponse<Movie>.self)
            .asObservable()
    }
    
    func movieSimilar(id: Int, page: Int) -> Observable<PageResponse<Movie>> {
        return provider.rx
            .request(.similar(type: .movies, id: id, page: page, language: language))
            .retry(3)
            .map(PageResponse<Movie>.self)
            .asObservable()
    }
    
    func movieReviews(id: Int, page: Int) -> Observable<PageResponse<Review>> {
        return provider.rx
            .request(.reviews(type: .movies, id: id, page: page, language: .init(code: .en)))
            .retry(3)
            .map(PageResponse<Review>.self)
            .asObservable()
    }
}

// MARK: - TmdbTVShowService
extension TmdbAPI: TmdbTVShowService {
    func tvShows(chart: TVShowChart, page: Int) -> Observable<PageResponse<TVShow>> {
        return provider.rx
            .request(.tvShows(chart: chart, page: page, language: language, region: region))
            .retry(3)
            .map(PageResponse<TVShow>.self)
            .asObservable()
    }
    
    func tvShowDetails(id: Int) -> Observable<TVShow> {
        return provider.rx
            .request(.details(type: .tvShows, id: id, language: language))
            .retry(3)
            .map(TVShow.self)
            .asObservable()
    }
    
    func tvShowCredits(id: Int) -> Observable<[Person]> {
        return provider.rx
            .request(.credits(type: .tvShows, id: id, language: language))
            .retry(3)
            .map(ListResponse.self)
            .map{
                var credits: [Person] = $0.cast ?? []
                
                if let director = $0.crew?.filter({ $0.job == "Director" }).first {
                    credits.insert(director, at: 0)
                }
                
                return credits
            }
            .asObservable()
    }
    
    func tvShowVideos(id: Int) -> Observable<[VideoInfo]> {
        return provider.rx
            .request(.videos(type: .tvShows, id: id, language: language))
            .retry(3)
            .map(Response<VideoInfo>.self)
            .map{ $0.results ?? [] }
            .asObservable()
    }

    
    func tvShowImages(id: Int) -> Observable<[ImageInfo]> {
        return provider.rx
            .request(.images(type: .tvShows, id: id, language: language))
            .retry(3)
            .map(ListResponse.self)
            .map{ ($0.backdrops ?? []) + ($0.posters ?? []) }
            .asObservable()
    }
    
    func tvShowRecommendations(id: Int, page: Int) -> Observable<PageResponse<TVShow>> {
        return provider.rx
            .request(.recommendations(type: .tvShows, id: id, page: page, language: language))
            .retry(3)
            .map(PageResponse<TVShow>.self)
            .asObservable()
    }
    
    func tvShowSimilar(id: Int, page: Int) -> Observable<PageResponse<TVShow>> {
        return provider.rx
            .request(.similar(type: .tvShows, id: id, page: page, language: language))
            .retry(3)
            .map(PageResponse<TVShow>.self)
            .asObservable()
    }
    
    func tvShowReviews(id: Int, page: Int) -> Observable<PageResponse<Review>> {
        return provider.rx
            .request(.reviews(type: .tvShows, id: id, page: page, language: language))
            .retry(3)
            .map(PageResponse<Review>.self)
            .asObservable()
    }
}
    
// MARK: - TmdbPersonService
extension TmdbAPI: TmdbPersonService {
    
}

// MARK: - TmdbAuthService
extension TmdbAPI: TmdbAuthService {
    func createRequestToken() -> Observable<Auth> {
        return provider.rx
            .request(.createRequestToken)
            .retry(3)
            .map(Auth.self)
            .asObservable()
    }
    
    func createAccessToken(requestToken: String) -> Observable<Auth> {
        return provider.rx
            .request(.createAccessToken(requestToken: requestToken))
            .retry(3)
            .map(Auth.self)
            .asObservable()
    }
    
    func createSession(accessToken: String) -> Observable<Auth> {
        return provider.rx
            .request(.createSession(accessToken: accessToken))
            .retry(3)
            .map(Auth.self)
            .asObservable()
    }
}

// MARK: - TmdbAccountService
extension TmdbAPI: TmdbAccountService {
    func accountProfile(sessionID: String) -> Observable<User> {
        return provider.rx
            .request(.accountProfile(sessionID: sessionID))
            .retry(3)
            .map(User.self)
            .asObservable()
    }
    
    func accountStates(sessionID: String?, type: ContentsType, id: Int) -> Observable<AccountStates> {
        guard let sessionID = sessionID else {
            return Observable.just(AccountStates())
        }

        return provider.rx
            .request(.accountStates(sessionID: sessionID, type: type, id: id))
            .retry(3)
            .map(AccountStates.self)
            .asObservable()
    }
    
    func accountMovieRecommendations(accountID: String, page: Int, sortBy: Sort) -> Observable<PageResponse<Movie>> {
        return provider.rx
            .request(.accountRecommendations(accountID: accountID, type: .movies, page: page, sortBy: sortBy))
            .retry(3)
            .map(PageResponse<Movie>.self)
            .asObservable()
    }
    
    func accountTvRecommendations(accountID: String, page: Int, sortBy: Sort) -> Observable<PageResponse<TVShow>> {
        return provider.rx
            .request(.accountRecommendations(accountID: accountID, type: .tvShows, page: page, sortBy: sortBy))
            .retry(3)
            .map(PageResponse<TVShow>.self)
            .asObservable()
    }
    
    func markFavorite(accountID: String, sessionID: String, type: ContentsType, id: Int, add: Bool) -> Observable<Void> {
        return provider.rx
            .request(.markFavorite(accountID: accountID, sessionID: sessionID, type: type, id: id, add: add))
            .retry(3)
            .asObservable()
            .mapToVoid()
    }
    
    func markWatchlist(accountID: String, sessionID: String, type: ContentsType, id: Int, add: Bool) -> Observable<Void> {
        return provider.rx
            .request(.markWatchlist(accountID: accountID, sessionID: sessionID, type: type, id: id, add: add))
            .retry(3)
            .asObservable()
            .mapToVoid()
    }
    
    func favoriteMovies(accountID: String, page: Int, sortBy: Sort?) -> Observable<PageResponse<Movie>> {
        return provider.rx
            .request(.favorites(accountID: accountID, type: .movies, page: page, sortBy: sortBy))
            .retry(3)
            .map(PageResponse<Movie>.self)
            .asObservable()
    }
    
    func favoriteTvShows(accountID: String, page: Int, sortBy: Sort?) -> Observable<PageResponse<TVShow>> {
        return provider.rx
            .request(.favorites(accountID: accountID, type: .tvShows, page: page, sortBy: sortBy))
            .retry(3)
            .map(PageResponse<TVShow>.self)
            .asObservable()
    }

}

// MARK: - TmdbConfigService
extension TmdbAPI: TmdbConfigService {
func languages() -> Observable<[Language]> {
        return provider.rx
            .request(.languages)
            .retry(3)
            .map([Language].self)
            .asObservable()
    }
    
    func countries() -> Observable<[Country]> {
        return provider.rx
            .request(.countries)
            .retry(3)
            .map([Country].self)
            .asObservable()
    }
    
    func genres(type: ContentsType) -> Observable<[Genre]> {
        return provider.rx
            .request(.genres(type: type))
            .retry(3)
            .map(ListResponse.self)
            .map { $0.genres ?? [] }
            .asObservable()
    }
}
