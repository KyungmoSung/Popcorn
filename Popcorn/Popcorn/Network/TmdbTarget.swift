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
    static private let readAccessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5NGJiZjE4ZGZhMjQ5ZDljNDcyOWRlYmJiZDZhN2E5NSIsInN1YiI6IjViZTRlYmYyOTI1MTQxNWM2YjAzNzk2YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.tnXWqKXrGg-l6eNh5Cg-V_u_9fAbexa__UmFyDRv5JI"
    
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
    
    // Auth
    case createRequestToken
    case createAccessToken(requestToken: String)
    case createSession(accessToken: String)
    
    // Account
    case accountProfile(sessionID: String)
    case accountStates(sessionID: String, type: ContentsType, id: Int)
    case accountRecommendations(accountID: String, type: ContentsType, page: Int, sortBy: Sort?)
    case rate(sessionID: String, type: ContentsType, id: Int, rateValue: Int)
    case deleteRating(sessionID: String, type: ContentsType, id: Int)
    case markFavorite(accountID: String, sessionID: String, type: ContentsType, id: Int, add: Bool)
    case markWatchlist(accountID: String, sessionID: String, type: ContentsType, id: Int, add: Bool)
    case favorites(accountID: String, type: ContentsType, page: Int, sortBy: Sort?)
    case rated(accountID: String, type: ContentsType, page: Int, sortBy: Sort?)
}

extension TmdbTarget: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org")!
    }
    
    var path: String {
        switch self {
        case .languages:                                            return "/3/configuration/languages"
        case .countries:                                            return "/3/configuration/countries"
        case .jobs:                                                 return "/3/configuration/jobs"
        case let .genres(type):                                     return "/3/genre/\(type.path)/list"
        
        case let .movies(chart, _, _, _):                           return "/3/movie/\(chart.path)"
            
        case let .tvShows(chart, _, _, _):                          return "/3/tv/\(chart.path)"
        case let .episodeGroups(id):                                return "/3/tv/\(id)/episode_groups"
        
        case let .details(type, id, _):                             return "/3/\(type.path)/\(id)"
        case let .credits(type, id, _):                             return "/3/\(type.path)/\(id)/credits"
        case let .videos(type, id, _):                              return "/3/\(type.path)/\(id)/videos"
        case let .images(type, id, _):                              return "/3/\(type.path)/\(id)/images"
        case let .recommendations(type, id, _, _):                  return "/3/\(type.path)/\(id)/recommendations"
        case let .similar(type, id, _, _):                          return "/3/\(type.path)/\(id)/similar"
        case let .reviews(type, id, _, _):                          return "/3/\(type.path)/\(id)/reviews"
            
        case .createRequestToken:                                   return "/4/auth/request_token"
        case .createAccessToken:                                    return "/4/auth/access_token"
        case .createSession:                                        return "/3/authentication/session/convert/4"
            
        case .accountProfile:                                       return "/3/account"
        case let .accountStates(_, type, id):                       return "/3/\(type.path)/\(id)/account_states"
        case let .accountRecommendations(accountID, type, _, _):    return "/4/account/\(accountID)/\(type.path)/recommendations"
        case let .rate(_, type, id, _):                             return "/3/\(type.path)/\(id)/rating"
        case let .deleteRating(_, type, id):                        return "/3/\(type.path)/\(id)/rating"
        case let .markFavorite(accountID, _, _, _, _):              return "/3/account/\(accountID)/favorite"
        case let .markWatchlist(accountID, _, _, _, _):             return "/3/account/\(accountID)/watchlist"
            
        case let .favorites(accountID, type, _, _):                 return "/4/account/\(accountID)/\(type.path)/favorites"
        case let .rated(accountID, type, _, _):                     return "4/account/\(accountID)/\(type.path)/rated"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createRequestToken,
                .createAccessToken,
                .createSession,
                .rate,
                .markFavorite,
                .markWatchlist:
            return .post
        case .deleteRating:
            return .delete
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        var params: [String: Any] = ["api_key": TmdbTarget.key]
        var bodyParams: [String: Codable] = [:]
        
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
        case .createRequestToken:
            params["redirect_to"] = "popcorn://auth"
        case let .createAccessToken(requestToken):
            params["request_token"] = requestToken
        case let .createSession(accessToken):
            params["access_token"] = accessToken
        case let .accountProfile(sessionID):
            params["session_id"] = sessionID
        case let .accountStates(sessionID, _, _):
            params["session_id"] = sessionID
        case let .accountRecommendations(accountID, _, page, sort):
            params["account_id"] = accountID
            params["page"] = page
            params["sort_by"] = sort?.param
        case let .rate(sessionID, _, _, rateValue):
            params["session_id"] = sessionID
            bodyParams["value"] = rateValue
        case let .deleteRating(sessionID, _, _):
            params["session_id"] = sessionID
        case let .markFavorite(_, sessionID, type, id, add):
            bodyParams["media_type"] = type.path
            bodyParams["media_id"] = id
            bodyParams["favorite"] = add

            params["session_id"] = sessionID
        case let .markWatchlist(_, sessionID, type, id, add):
            bodyParams["media_type"] = type.path
            bodyParams["media_id"] = id
            bodyParams["watchlist"] = add
            
            params["session_id"] = sessionID
        case let .favorites(_, _, page, sort):
            params["page"] = page
            params["sort_by"] = sort?.param
        case let .rated(_, _, page, sort):
            params["page"] = page
            params["sort_by"] = sort?.param
        default:
            break
        }
        
        if !bodyParams.isEmpty {
            return .requestCompositeParameters(bodyParameters: bodyParams,
                                               bodyEncoding: JSONEncoding.default,
                                               urlParameters: params)
        } else {
            return .requestParameters(parameters: params,
                                      encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        var headers = ["Authorization": "Bearer \(TmdbTarget.readAccessToken)"]
        
        switch self {
        case .markFavorite, .markWatchlist:
            headers["Content-Type"] = "application/json"
        default:
            break
        }
        
        return headers
    }
}
