//
//  Enums.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/28.
//

import Foundation

protocol SectionType {
    var title: String { get }
    var height: CGFloat { get }
    var rawValue: Int { get }
}

struct Section {
    struct Home {
        enum Movie: Int, CaseIterable, SectionType {
            case popular
            case nowPlaying
            case topRated
            case upcoming

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
                }
            }
            
            var height: CGFloat {
                return 220
            }
        }
        
        enum TVShow: Int, CaseIterable, SectionType {
            case popular
            case topRated
            case tvAiringToday
            case tvOnTheAir
            
            var title: String {
                switch self {
                case .popular:
                    return "popular".localized
                case .tvAiringToday:
                    return "tvAiringToday".localized
                case .topRated:
                    return "topRated".localized
                case .tvOnTheAir:
                    return "tvOnTheAir".localized
                }
            }
            
            var height: CGFloat {
                return 220
            }
        }
    }

    struct Detail {
        enum Movie: Int, CaseIterable, SectionType {
            case title
            case synopsis
            case credit
            case detail
            case image
            case video
            case review
            case recommendation
            case similar
            
            var title: String {
                switch self {
                case .title:
                    return "title".localized
                case .synopsis:
                    return "synopsis".localized
                case .credit:
                    return "credit".localized
                case .detail:
                    return "detail".localized
                case .image:
                    return "image".localized
                case .video:
                    return "video".localized
                case .review:
                    return "review".localized
                case .recommendation:
                    return "recommendation".localized
                case .similar:
                    return "similar".localized
                }
            }
            
            var height: CGFloat {
                switch self {
                case .title:
                    return 0
                case .synopsis:
                    return 100
                case .credit:
                    return 160
                case .detail:
                    return 80
                case .image:
                    return 160
                case .video:
                    return 160
                case .review:
                    return 250
                case .recommendation:
                    return 200
                case .similar:
                    return 200
                }
            }
        }
        
        enum TVShow: Int, CaseIterable, SectionType {
            case title
            case synopsis
            case credit
            case detail
            case season
            case episodeGroup
            case image
            case video
            case review
            case recommendation
            case similar
            
            var title: String {
                switch self {
                case .title:
                    return "title".localized
                case .synopsis:
                    return "synopsis".localized
                case .credit:
                    return "credit".localized
                case .detail:
                    return "detail".localized
                case .season:
                    return "season".localized
                case .episodeGroup:
                    return "episodeGroup".localized
                case .image:
                    return "image".localized
                case .video:
                    return "video".localized
                case .review:
                    return "review".localized
                case .recommendation:
                    return "recommendation".localized
                case .similar:
                    return "similar".localized
                }
            }
            
            var height: CGFloat {
                switch self {
                case .title:
                    return 0
                case .synopsis:
                    return 100
                case .credit:
                    return 160
                case .detail:
                    return 80
                case .season:
                    return 200
                case .episodeGroup:
                    return 200
                case .image:
                    return 160
                case .video:
                    return 160
                case .review:
                    return 250
                case .recommendation:
                    return 200
                case .similar:
                    return 200
                }
            }
        }
        
        enum Person: Int, CaseIterable, SectionType {
            case title
            case biography
            case detail
            case movies
            case tvShows
            case image
            
            var title: String {
                switch self {
                case .title:
                    return "title".localized
                case .biography:
                    return "biography".localized
                case .detail:
                    return "detail".localized
                case .movies:
                    return "movies".localized
                case .tvShows:
                    return "tvShows".localized
                case .image:
                    return "image".localized
                
                
                }
            }
            
            var height: CGFloat {
                switch self {
                case .title:
                    return 0
                case .biography:
                    return 100
                case .detail:
                    return 80
                case .movies:
                    return 200
                case .tvShows:
                    return 200
                case .image:
                    return 160
                }
            }
        }
    }
}

enum MediaType: String {
    case image
    case video
}

enum ImageType: Int, CaseIterable {
    case backdrop
    case poster
    
    var title: String {
        switch self {
        case .backdrop:
            return "backdrop".localized
        case .poster:
            return "poster".localized
        }
    }
}

enum ContentsType: Int, CaseIterable {
    case movies
    case tvShows
    
    var title: String {
        switch self {
        case .movies:
            return "movies".localized
        case .tvShows:
            return "tvShows".localized
        }
    }
    
    var path: String {
        switch self {
        case .movies:
            return "movie"
        case .tvShows:
            return "tv"
        }
    }
}
