//
//  TmdbAPI.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/26.
//

import Foundation
import RxSwift
import Moya

final class TmdbAPI: TmdbService {
    lazy var provider = MoyaProvider<TmdbTarget>(plugins: [NetworkLoggerPlugin()])
    
    private var language: Language
    private var region: Country
    
    init(language: Language = Localize.currentLanguage, region: Country = Localize.currentRegion) {
        self.language = language
        self.region = region
    }
        
    // MARK: - TmdbMoviesService
    func movies(chart: MovieChart, page: Int) -> Observable<[_Movie]> {
        return provider.rx
            .request(target(for: chart, page: page))
            .retry(3)
            .map(PageResponse<_Movie>.self)
            .map { ($0.results ?? []) }
            .asObservable()
    }
    
    // MARK: - TmdbTVShowsService
    func tvShows(chart: TVShowChart, page: Int) -> Observable<[_TVShow]> {
        return provider.rx
            .request(target(for: chart, page: page))
            .retry(3)
            .map(PageResponse<_TVShow>.self)
            .map { ($0.results ?? []) }
            .asObservable()
    }
    
    // MARK: - TmdbPeopleService
    
    // MARK: - TmdbAuthService
    
    // MARK: - TmdbConfigService
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
    
    func movieGenres() -> Observable<[Genre]> {
        return provider.rx
            .request(.movieGenres)
            .retry(3)
            .map(ListResponse.self)
            .map { $0.genres ?? [] }
            .asObservable()
    }
    
    func tvGenres() -> Observable<[Genre]> {
        return provider.rx
            .request(.tvGenres)
            .retry(3)
            .map(ListResponse.self)
            .map { $0.genres ?? [] }
            .asObservable()
    }
}

extension TmdbAPI {
    private func target(for chart: MovieChart, page: Int) -> TmdbTarget {
        switch chart {
        case .nowPlaying:   return .nowPlayingMovies(page: page, language: language, region: region)
        case .upcoming:     return .upcomingMovies(page: page, language: language, region: region)
        case .popular:      return .popularMovies(page: page, language: language, region: region)
        case .topRated:     return .topRatedMovies(page: page, language: language, region: region)
        }
    }
    
    private func target(for chart: TVShowChart, page: Int) -> TmdbTarget {
        switch chart {
        case .airingToday:  return .airingTodayTvShows(page: page, language: language, region: region)
        case .onTheAir:     return .onTheAirTvShows(page: page, language: language, region: region)
        case .popular:      return .popularTvShows(page: page, language: language, region: region)
        case .topRated:     return .topRatedTvShows(page: page, language: language, region: region)
        }
    }
}
