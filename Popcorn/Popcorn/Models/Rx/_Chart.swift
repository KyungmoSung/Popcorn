//
//  Chart.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/27.
//

import Foundation

enum TVShowChart: Int, CaseIterable {
    case airingToday
    case onTheAir
    case popular
    case topRated
    
    var title: String {
        switch self {
        case .airingToday:
            return "airingToday".localized
        case .onTheAir:
            return "onTheAir".localized
        case .popular:
            return "popular".localized
        case .topRated:
            return "nowPlaying".localized
        }
    }
    
    var path: String {
        switch self {
        case .airingToday:
            return "/airing_today"
        case .onTheAir:
            return "/on_the_air"
        case .popular:
            return "/popular"
        case .topRated:
            return "/top_rated"
        }
    }
}

enum MovieChart: Int, CaseIterable {
    case nowPlaying
    case upcoming
    case popular
    case topRated
    
    var title: String {
        switch self {
        case .nowPlaying:
            return "nowPlaying".localized
        case .upcoming:
            return "upcoming".localized
        case .popular:
            return "popular".localized
        case .topRated:
            return "topRated".localized
        }
    }
    
    var path: String {
        switch self {
        case .nowPlaying:
            return "/now_playing"
        case .upcoming:
            return "/upcoming"
        case .popular:
            return "/popular"
        case .topRated:
            return "/top_rated"
        }
    }
}
