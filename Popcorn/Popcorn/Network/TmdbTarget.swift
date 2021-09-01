//
//  TmdbTarget.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/25.
//

import Foundation
import Moya

enum TmdbTarget {
    static private let key = "94bbf18dfa249d9c4729debbbd6a7a95"
    
    // Config
    case languages
    case countries
    case jobs
    case movieGenres
    case tvGenres
    
    // 영화 차트
    case popularMovies(page: Int, language: Language, region: Country)
    case topRatedMovies(page: Int, language: Language, region: Country)
    case nowPlayingMovies(page: Int, language: Language, region: Country)
    case upcomingMovies(page: Int, language: Language, region: Country)
    
    // TV 차트
    case airingTodayTvShows(page: Int, language: Language, region: Country)
    case onTheAirTvShows(page: Int, language: Language, region: Country)
    case popularTvShows(page: Int, language: Language, region: Country)
    case topRatedTvShows(page: Int, language: Language, region: Country)
}

extension TmdbTarget: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    var path: String {
        switch self {
        case .languages:            return "/configuration/languages"
        case .countries:            return "/configuration/countries"
        case .jobs:                 return "/configuration/jobs"
        case .movieGenres:          return "/genre/movie/list"
        case .tvGenres:             return "/genre/tv/list"
        
        case .popularMovies:        return "/movie/popular"
        case .topRatedMovies:       return "/movie/top_rated"
        case .nowPlayingMovies:     return "/movie/now_playing"
        case .upcomingMovies:       return "/movie/upcoming"
            
        case .airingTodayTvShows:   return "/tv/airing_today"
        case .onTheAirTvShows:      return "/tv/on_the_air"
        case .popularTvShows:       return "/tv/popular"
        case .topRatedTvShows:      return "/tv/top_rated"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        var params: [String: Any] = ["api_key": TmdbTarget.key]
        
        switch self {
        case let .popularMovies(page, language, region),
             let .topRatedMovies(page, language, region),
             let .nowPlayingMovies(page, language, region),
             let .upcomingMovies(page, language, region),
             let .airingTodayTvShows(page, language, region),
             let .onTheAirTvShows(page, language, region),
             let .popularTvShows(page, language, region),
             let .topRatedTvShows(page, language, region):
            
            params["language"] = language.code.rawValue
            params["page"] = page
            params["region"] = region.code.rawValue
        default:
            break
        }
        
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return nil
    }
}
