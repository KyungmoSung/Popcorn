//
//  Constants.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/29.
//

import Foundation

enum AppConstants {
    enum Key {
        static let tmdb = "94bbf18dfa249d9c4729debbbd6a7a95"
    }
    
    enum Domain {
        static let tmdbSite                 = "https://www.themoviedb.org"
        static let tmdbAPI                  = "https://api.themoviedb.org/3"
        static let tmdbImage                = "https://image.tmdb.org/t/p/original"
        static let youtubeEmbed             = "https://www.youtube.com/embed/"
    }
    
    enum API {
        enum Auth {
            static let createRequestToken                   = "/authentication/token/new"
            static let validateRequestToken                 = "/authentication/token/validate_with_login"
            static let createSession                        = "/authentication/session/new"
        }
        
        enum Movie {
            static let getPopular                           = "/movie/popular"
            static let getTopRated                          = "/movie/top_rated"
            static let getNowPlaying                        = "/movie/now_playing"
            static let getUpcoming                          = "/movie/upcoming"
            static let searchMovies                         = "/search/movie"
            static let getGenreList                         = "/genre/movie/list"
            
            static func getDetails(_ movieId: Int)          -> String { return "/movie/\(movieId)" }
            static func getCredits(_ movieId: Int)          -> String { return "/movie/\(movieId)/credits" }
            static func getRecommendations(_ movieId: Int)  -> String { return "/movie/\(movieId)/recommendations" }
            static func getSimilar(_ movieId: Int)          -> String { return "/movie/\(movieId)/similar" }
            static func getVideos(_ movieId: Int)           -> String { return "/movie/\(movieId)/videos" }
            static func getImages(_ movieId: Int)           -> String { return "/movie/\(movieId)/images" }
        }
    }
}
