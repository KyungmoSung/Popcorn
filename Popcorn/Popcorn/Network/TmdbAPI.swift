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
    lazy var provider = MoyaProvider<TmdbTarget>()
    
    private var language: Language
    private var region: Country
    
    init(language: Language = Localize.currentLanguage, region: Country = Localize.currentRegion) {
        self.language = language
        self.region = region
    }
        
    private func target(for chart: MovieChart, page: Int) -> TmdbTarget {
        switch chart {
        case .nowPlaying:
            return .nowPlayingMovies(page: page, language: language, region: region)
        case .upcoming:
            return .upcomingMovies(page: page, language: language, region: region)
        case .popular:
            return .popularMovies(page: page, language: language, region: region)
        case .topRated:
            return .topRatedMovies(page: page, language: language, region: region)
        }
    }
    
    private func target(for chart: TVShowChart, page: Int) -> TmdbTarget {
        switch chart {
        case .airingToday:
            return .airingTodayTvShows(page: page, language: language, region: region)
        case .onTheAir:
            return .onTheAirTvShows(page: page, language: language, region: region)
        case .popular:
            return .popularTvShows(page: page, language: language, region: region)
        case .topRated:
            return .topRatedTvShows(page: page, language: language, region: region)
        }
    }
    
    func movies(chart: MovieChart, page: Int) -> Observable<[_Movie]> {
        return provider.rx
            .request(target(for: chart, page: page))
            .retry(3)
            .map(PageResponse<_Movie>.self)
            .map { ($0.results ?? []) }
            .asObservable()
    }
    
    func tvShows(chart: TVShowChart, page: Int) -> Observable<[_TVShow]> {
        return provider.rx
            .request(target(for: chart, page: page))
            .retry(3)
            .map(PageResponse<_TVShow>.self)
            .map { ($0.results ?? []) }
            .asObservable()
    }
}

