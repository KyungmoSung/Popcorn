//
//  _SectionType.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/18.
//

import Foundation

struct _SectionType {
    enum Home: Equatable {
        case movie(Movie)
        case tvShow(TVShow)
        
        enum TVShow: Int, CaseIterable {
            case tvAiringToday
            case tvOnTheAir
        }
        
        enum Movie: Int, CaseIterable {
            case popular
            case nowPlaying
            case topRated
            case upcoming
            case tvAiringToday
            case tvOnTheAir
            
            var title: String {
                switch self {
                case .popular:
                    return "popular".localized
                case .nowPlaying:
                    return "nowPlaying".localized
                case .topRated:
                    return "topRated".localized
                case .upcoming:
                    return "upcoming".localized
                case .tvAiringToday:
                    return "tvAiringToday".localized
                case .tvOnTheAir:
                    return "tvOnTheAir".localized
                }
            }
        }
    }
    
}
