//
//  TmdbService.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/26.
//

import Foundation
import RxSwift

typealias TmdbService = TmdbMoviesService & TmdbTVShowsService & TmdbPeopleService & TmdbAuthService

protocol TmdbMoviesService {
    func popularMovies(page: Int) -> Observable<[_Movie]>
    func topRatedMovies(page: Int) -> Observable<[_Movie]>
    func nowPlayingMovies(page: Int) -> Observable<[_Movie]>
    func upcomingMovies(page: Int) -> Observable<[_Movie]>
}

protocol TmdbTVShowsService {
    
}

protocol TmdbPeopleService {
    
}

protocol TmdbAuthService {
    
}
