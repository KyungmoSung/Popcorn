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
            static let createRequestToken              = "/authentication/token/new"
            static let validateRequestToken            = "/authentication/token/validate_with_login"
            static let createSession                   = "/authentication/session/new"
        }
        
        enum Movie {
            static let getPopular                      = "/movie/popular"
            static let getTopRated                     = "/movie/top_rated"
            static let getNowPlaying                   = "/movie/now_playing"
            static let getUpcoming                     = "/movie/upcoming"
            static let searchMovies                    = "/search/movie"
            static let getGenreList                    = "/genre/movie/list"
            
            static func getDetails(_ id: Int)          -> String { return "/movie/\(id)" }
            static func getCredits(_ id: Int)          -> String { return "/movie/\(id)/credits" }
            static func getRecommendations(_ id: Int)  -> String { return "/movie/\(id)/recommendations" }
            static func getSimilar(_ id: Int)          -> String { return "/movie/\(id)/similar" }
            static func getVideos(_ id: Int)           -> String { return "/movie/\(id)/videos" }
            static func getImages(_ id: Int)           -> String { return "/movie/\(id)/images" }
            static func getReviews(_ id: Int)          -> String { return "/movie/\(id)/reviews" }
        }
        
        enum TVShow {
            static let getPopular                      = "/tv/popular"
            static let getTopRated                     = "/tv/top_rated"
            static let getTvAiringToday                = "/tv/airing_today"
            static let getTvOnTheAir                   = "/tv/on_the_air"
            
            static func getDetails(_ id: Int)          -> String { return "/tv/\(id)" }
        }
    }
}
