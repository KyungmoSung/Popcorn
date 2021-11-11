//
//  _Section.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/18.
//

import Foundation

protocol _SectionType {
    var title: String? { get }
    var height: CGFloat { get }
    var expandable: Bool { get }
}

enum HomeSection: _SectionType {
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

enum DetailSection: _SectionType {
    case movie(Informations.Movie)
    case tvShow(Informations.TVShow)
    
    var title: String? {
        switch self {
        case let .movie(information as _SectionType),
             let .tvShow(information as _SectionType):
            return information.title
        }
    }
    
    var height: CGFloat {
        switch self {
        case let .movie(information as _SectionType),
             let .tvShow(information as _SectionType):
            return information.height
        }
    }
    
    var expandable: Bool {
        switch self {
        case let .movie(information as _SectionType),
             let .tvShow(information as _SectionType):
            return information.expandable
        }
    }
}

enum ListSection: _SectionType {
    case movieChart(MovieChart)
    case tvShowChart(TVShowChart)
    case movieInformation(Informations.Movie, Int)
    case tvShowInformation(Informations.TVShow, Int)
    case recommendations(ContentsType)
    case favorites(ContentsType)
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
}

enum MyPageSection: _SectionType {
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
