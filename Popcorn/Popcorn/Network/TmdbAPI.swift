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
    
    func popularMovies(page: Int) -> Observable<[_Movie]> {
        return provider.rx
            .request(.popularMovies(page: page,
                                    language: Localize.currentLanguage,
                                    region: Localize.currentRegion))
            .retry(3)
            .map(PageResponse<_Movie>.self)
            .map { ($0.results ?? []) }
            .asObservable()
    }
    
    func topRatedMovies(page: Int) -> Observable<[_Movie]> {
        return provider.rx
            .request(.topRatedMovies(page: page,
                                    language: Localize.currentLanguage,
                                    region: Localize.currentRegion))
            .retry(3)
            .map(PageResponse<_Movie>.self)
            .map { ($0.results ?? []) }
            .asObservable()
    }
    
    func nowPlayingMovies(page: Int) -> Observable<[_Movie]> {
        return provider.rx
            .request(.nowPlayingMovies(page: page,
                                    language: Localize.currentLanguage,
                                    region: Localize.currentRegion))
            .retry(3)
            .map(PageResponse<_Movie>.self)
            .map { ($0.results ?? []) }
            .asObservable()
    }
    
    func upcomingMovies(page: Int) -> Observable<[_Movie]> {
        return provider.rx
            .request(.upcomingMovies(page: page,
                                    language: Localize.currentLanguage,
                                    region: Localize.currentRegion))
            .retry(3)
            .map(PageResponse<_Movie>.self)
            .map { ($0.results ?? []) }
            .asObservable()
    }
}

