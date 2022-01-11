//
//  Section.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/18.
//

import Foundation
import CoreGraphics

protocol SectionType {
    var title: String? { get }
    var height: CGFloat { get }
    var expandable: Bool { get }
}

enum HomeSection: SectionType {
    case movie(MovieChart)
    case tvShow(TVShowChart)
    
    var title: String? {
        switch self {
        case .movie(let chart):
            return chart.title
        case .tvShow(let chart):
            return chart.title
        }
    }
    
    var height: CGFloat {
        return 200
    }
    
    var expandable: Bool {
        return true
    }
    
    var displayType: ImageType {
        switch self {
        case .movie(let chart) where chart == .nowPlaying:
            return .backdrop
        case .tvShow(let chart) where chart == .airingToday:
            return .backdrop
        default:
            return .poster
        }
    }
}

enum DetailSection: Int, CaseIterable, SectionType {
    case title
    case synopsis
    case credit
    case report
    case season
    case episodeGroup
    case image
    case video
    case review
    case recommendation
    case similar
    
    var title: String? {
        switch self {
        case .title:
            return nil
        case .synopsis:
            return "synopsis".localized
        case .credit:
            return "credit".localized
        case .report:
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
        case .report:
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
            return 250
        case .similar:
            return 250
        }
    }
    
    var expandable: Bool {
        return true
    }
}

enum ListSection: SectionType {
    case movieChart(MovieChart)
    case tvShowChart(TVShowChart)
    case movieInformation(Informations.Movie, Int)
    case tvShowInformation(Informations.TVShow, Int)
    case recommendations(ContentsType)
    case favorites
    case watchlist
    case rated
    case credits
    
    var title: String? {
        switch self {
        case let .movieChart(chart):
            return chart.title
        case let .tvShowChart(chart):
            return chart.title
        case let .movieInformation(info, _):
            return info.title
        case let .tvShowInformation(info, _):
            return info.title
        case .recommendations:
            return "recommendation".localized
        case .favorites:
            return "favorite".localized
        case .watchlist:
            return "watchlist".localized
        case .rated:
            return "rated".localized
        case .credits:
            return "credits".localized
        }
    }
    
    var height: CGFloat {
        return 100
    }
    
    var expandable: Bool {
        return false
    }
    
    var segmentTitles: [String]? {
        switch self {
        case .recommendations,
                .favorites,
                .watchlist,
                .rated:
            return ContentsType.allCases.map{ $0.title }
        default:
            return nil
        }
    }
    
    func sortOptions(for type: ContentsType? = nil) -> [Sort]? {
        switch (self, type) {
        case let (.recommendations, .some(type)):
            return Sort.forRecommendations(type)
        case let (.favorites, .some(type)):
            return Sort.forFavorite(type)
        case let (.watchlist, .some(type)):
            return Sort.forWatchlist(type)
        case let (.rated, .some(type)):
            return Sort.forRated(type)
        default:
            return nil
        }
    }
}

enum MyPageSection: SectionType {
    case menu
    
    var title: String? {
        return nil
    }
    
    var height: CGFloat {
        return 100
    }
    
    var expandable: Bool {
        return false
    }
}
