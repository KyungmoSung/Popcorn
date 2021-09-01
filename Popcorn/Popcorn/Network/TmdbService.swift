//
//  TmdbService.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/26.
//

import Foundation
import RxSwift

typealias TmdbService = TmdbMoviesService & TmdbTVShowsService & TmdbPeopleService & TmdbAuthService & TmdbConfigService

protocol TmdbMoviesService {
    func movies(chart: MovieChart, page: Int) -> Observable<[_Movie]>
}

protocol TmdbTVShowsService {
    func tvShows(chart: TVShowChart, page: Int) -> Observable<[_TVShow]>
}

protocol TmdbPeopleService {
    
}

protocol TmdbAuthService {
    
}

protocol TmdbConfigService {
    func languages() -> Observable<[Language]>
    func countries() -> Observable<[Country]>
    func movieGenres() -> Observable<[Genre]>
    func tvGenres() -> Observable<[Genre]>
}
