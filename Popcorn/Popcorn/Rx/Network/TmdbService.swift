//
//  TmdbService.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/26.
//

import Foundation
import RxSwift

typealias TmdbService = TmdbMovieService & TmdbTVShowService & TmdbPersonService & TmdbAuthService & TmdbConfigService

protocol TmdbMovieService {
    func movies(chart: MovieChart, page: Int) -> Observable<[_Movie]>
    func movieDetails(id: Int) -> Observable<_Movie>
    func movieCredits(id: Int) -> Observable<[Person]>
    func movieVideos(id: Int) -> Observable<[VideoInfo]>
    func movieImages(id: Int) -> Observable<[ImageInfo]>
    func movieRecommendations(id: Int, page: Int) -> Observable<[_Movie]>
    func movieSimilar(id: Int, page: Int) -> Observable<[_Movie]>
    func movieReviews(id: Int, page: Int) -> Observable<[Review]>
    
}

protocol TmdbTVShowService {
    func tvShows(chart: TVShowChart, page: Int) -> Observable<[_TVShow]>
    func tvShowDetails(id: Int) -> Observable<_TVShow>
    func tvShowCredits(id: Int) -> Observable<[Person]>
    func tvShowVideos(id: Int) -> Observable<[VideoInfo]>
    func tvShowImages(id: Int) -> Observable<[ImageInfo]>
    func tvShowRecommendations(id: Int, page: Int) -> Observable<[_TVShow]>
    func tvShowSimilar(id: Int, page: Int) -> Observable<[_TVShow]>
    func tvShowReviews(id: Int, page: Int) -> Observable<[Review]>
}

protocol TmdbPersonService {
    
}

protocol TmdbAuthService {
    
}

protocol TmdbConfigService {
    func languages() -> Observable<[Language]>
    func countries() -> Observable<[Country]>
    func genres(type: ContentsType) -> Observable<[Genre]>
}
