//
//  TmdbService.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/26.
//

import Foundation
import RxSwift

typealias TmdbService = TmdbMovieService & TmdbTVShowService & TmdbPersonService & TmdbAuthService & TmdbAccountService & TmdbConfigService

protocol TmdbMovieService {
    func movies(chart: MovieChart, page: Int) -> Observable<PageResponse<Movie>>
    func movieDetails(id: Int) -> Observable<Movie>
    func movieCredits(id: Int) -> Observable<[Person]>
    func movieVideos(id: Int) -> Observable<[VideoInfo]>
    func movieImages(id: Int) -> Observable<[ImageInfo]>
    func movieRecommendations(id: Int, page: Int) -> Observable<PageResponse<Movie>>
    func movieSimilar(id: Int, page: Int) -> Observable<PageResponse<Movie>>
    func movieReviews(id: Int, page: Int) -> Observable<PageResponse<Review>>
    
}

protocol TmdbTVShowService {
    func tvShows(chart: TVShowChart, page: Int) -> Observable<PageResponse<TVShow>>
    func tvShowDetails(id: Int) -> Observable<TVShow>
    func tvShowCredits(id: Int) -> Observable<[Person]>
    func tvShowVideos(id: Int) -> Observable<[VideoInfo]>
    func tvShowImages(id: Int) -> Observable<[ImageInfo]>
    func tvShowRecommendations(id: Int, page: Int) -> Observable<PageResponse<TVShow>>
    func tvShowSimilar(id: Int, page: Int) -> Observable<PageResponse<TVShow>>
    func tvShowReviews(id: Int, page: Int) -> Observable<PageResponse<Review>>
}

protocol TmdbPersonService {
    
}

protocol TmdbAuthService {
    func createRequestToken() -> Observable<Auth>
    func createAccessToken(requestToken: String) -> Observable<Auth>
    func createSession(accessToken: String) -> Observable<Auth>
}

protocol TmdbAccountService {
    func accountProfile(sessionID: String) -> Observable<User>
    func accountStates(sessionID: String?, type: ContentsType, id: Int) -> Observable<AccountStates>
    func accountMovieRecommendations(accountID: String, page: Int, sortBy: Sort) -> Observable<PageResponse<Movie>>
    func accountTvRecommendations(accountID: String, page: Int, sortBy: Sort) -> Observable<PageResponse<TVShow>>
    func markFavorite(accountID: String, sessionID: String, type: ContentsType, id: Int, add: Bool) -> Observable<Void>
    func markWatchlist(accountID: String, sessionID: String, type: ContentsType, id: Int, add: Bool) -> Observable<Void>
    func favoriteMovies(accountID: String, page: Int, sortBy: Sort?) -> Observable<PageResponse<Movie>>
    func favoriteTvShows(accountID: String, page: Int, sortBy: Sort?) -> Observable<PageResponse<TVShow>>
}

protocol TmdbConfigService {
    func languages() -> Observable<[Language]>
    func countries() -> Observable<[Country]>
    func genres(type: ContentsType) -> Observable<[Genre]>
}
