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
    case genres(type: ContentsType)
    
    // Movie
    case movies(chart: MovieChart, page: Int, language: Language, region: Country)
    
    // TVShows
    case tvShows(chart: TVShowChart, page: Int, language: Language, region: Country)
    case episodeGroups(id: Int)
    
    // Detail
    case details(type: ContentsType, id: Int, language: Language)
    case credits(type: ContentsType, id: Int, language: Language)
    case videos(type: ContentsType, id: Int, language: Language)
    case images(type: ContentsType, id: Int, language: Language)
    case recommendations(type: ContentsType, id: Int, page: Int, language: Language)
    case similar(type: ContentsType, id: Int, page: Int, language: Language)
    case reviews(type: ContentsType, id: Int, page: Int, language: Language)
}

extension TmdbTarget: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    var path: String {
        switch self {
        case .languages:                            return "/configuration/languages"
        case .countries:                            return "/configuration/countries"
        case .jobs:                                 return "/configuration/jobs"
        case let .genres(type):                     return "/genre\(type.path)/list"
        
        case let .movies(chart, _, _, _):           return "/movie\(chart.path)"
            
        case let .tvShows(chart, _, _, _):          return "/tv\(chart.path)"
        case let .episodeGroups(id):                return "/tv/\(id)/episode_groups"
        
        case let .details(type, id, _):             return "\(type.path)/\(id)"
        case let .credits(type, id, _):             return "\(type.path)/\(id)/credits"
        case let .videos(type, id, _):              return "\(type.path)/\(id)/videos"
        case let .images(type, id, _):              return "\(type.path)/\(id)/images"
        case let .recommendations(type, id, _, _):  return "\(type.path)/\(id)/recommendations"
        case let .similar(type, id, _, _):          return "\(type.path)/\(id)/similar"
        case let .reviews(type, id, _, _):          return "\(type.path)/\(id)/reviews"
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
        case let .movies(_, page, language, region),
             let .tvShows(_, page, language, region):
            params["language"] = language.code.rawValue
            params["page"] = page
            params["region"] = region.code.rawValue
            
        case let .details(_, _, language),
             let .credits(_, _, language),
             let .videos(_, _, language),
             let .images(_, _, language):
            params["language"] = language.code.rawValue
            
        case let .recommendations(_, _, page, language),
             let .similar(_, _, page, language),
             let .reviews(_, _, page, language):
            params["language"] = language.code.rawValue
            params["page"] = page
            
        default:
            break
        }
        
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return nil
    }
}
