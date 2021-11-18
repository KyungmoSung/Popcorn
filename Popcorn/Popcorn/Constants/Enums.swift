//
//  Enums.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/28.
//

import Foundation
import CoreGraphics

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

enum Sort {
    case createdAt(_ orderBy: SortOrder)
    case title(_ orderBy: SortOrder)
    case popularity(_ orderBy: SortOrder)
    case releaseDate(_ orderBy: SortOrder)
    case revenue(_ orderBy: SortOrder)
    case primaryReleaseDate(_ orderBy: SortOrder)
    case originalTitle(_ orderBy: SortOrder)
    case voteAverage(_ orderBy: SortOrder)
    case voteCount(_ orderBy: SortOrder)
    case firstAirDate(_ orderBy: SortOrder)
    case name(_ orderBy: SortOrder)
    
    var param: String {
        switch self {
        case let .createdAt(orderBy):
            return "created_at.\(orderBy.rawValue)"
        case let .title(orderBy):
            return "title.\(orderBy.rawValue)"
        case let .popularity(orderBy):
            return "popularity.\(orderBy.rawValue)"
        case let .releaseDate(orderBy):
            return "release_date.\(orderBy.rawValue)"
        case let .revenue(orderBy):
            return "revenue.\(orderBy.rawValue)"
        case let .primaryReleaseDate(orderBy):
            return "primary_release_date.\(orderBy.rawValue)"
        case let .originalTitle(orderBy):
            return "original_title.\(orderBy.rawValue)"
        case let .voteAverage(orderBy):
            return "vote_average.\(orderBy.rawValue)"
        case let .voteCount(orderBy):
            return "vote_count.\(orderBy.rawValue)"
        case let .firstAirDate(orderBy):
            return "first_air_date.\(orderBy.rawValue)"
        case let .name(orderBy):
            return "name.\(orderBy.rawValue)"
        }
    }
    
    var title: String {
        switch self {
        case .createdAt:
            return "createdAt".localized + arrow
        case .title:
            return "title".localized + arrow
        case .popularity:
            return "popularity".localized + arrow
        case .releaseDate:
            return "releaseDate".localized + arrow
        case .revenue:
            return "revenue".localized + arrow
        case .primaryReleaseDate:
            return "primaryReleaseDate".localized + arrow
        case .originalTitle:
            return "originalTitle".localized + arrow
        case .voteAverage:
            return "voteAverage".localized + arrow
        case .voteCount:
            return "voteCount".localized + arrow
        case .firstAirDate:
            return "firstAirDate".localized + arrow
        case .name:
            return "name".localized + arrow
        }
    }
    
    var arrow: String {
        switch self {
        case let .createdAt(order),
            let .title(order),
            let .popularity(order),
            let .releaseDate(order),
            let .revenue(order),
            let .primaryReleaseDate(order),
            let .originalTitle(order),
            let .voteAverage(order),
            let .voteCount(order),
            let .firstAirDate(order),
            let .name(order):
            switch order {
            case .asc:
                return " ⬆"
            case .desc:
                return " ⬇"
            }
        }
    }
    
    static func forRecommendations(_ type: ContentsType) -> [Sort] {
        switch type {
        case .movies:
            return [.createdAt(.asc), .createdAt(.desc),
                    .releaseDate(.asc), .releaseDate(.desc),
                    .title(.asc), .title(.desc),
                    .voteAverage(.asc), .voteAverage(.desc)]
        case .tvShows:
            return [.firstAirDate(.asc), .firstAirDate(.desc),
                    .name(.asc), .name(.desc),
                    .voteAverage(.asc), .voteAverage(.desc),
                    .releaseDate(.asc), .releaseDate(.desc),
                    .title(.asc), .title(.desc)]
        }
    }
    
    static func forDiscover(_ type: ContentsType) -> [Sort] {
        return [.popularity(.asc), .popularity(.desc),
                .releaseDate(.asc), .releaseDate(.desc),
                .revenue(.asc), .revenue(.desc),
                .primaryReleaseDate(.asc), .primaryReleaseDate(.desc),
                .originalTitle(.asc), .originalTitle(.desc),
                .voteAverage(.asc), .voteAverage(.desc),
                .voteCount(.asc), .voteCount(.desc)]
    }
    
    static func forFavorite(_ type: ContentsType) -> [Sort] {
        switch type {
        case .movies:
            return [.createdAt(.asc), .createdAt(.desc),
                    .releaseDate(.asc), .releaseDate(.desc),
                    .title(.asc), .title(.desc),
                    .voteAverage(.asc), .voteAverage(.desc)]
        case .tvShows:
            return [.firstAirDate(.asc), .firstAirDate(.desc),
                    .name(.asc), .name(.desc),
                    .voteAverage(.asc), .voteAverage(.desc)]
        }
    }
    
    static func forWatchlist(_ type: ContentsType) -> [Sort] {
        switch type {
        case .movies:
            return [.createdAt(.asc), .createdAt(.desc),
                    .releaseDate(.asc), .releaseDate(.desc),
                    .title(.asc), .title(.desc),
                    .voteAverage(.asc), .voteAverage(.desc)]
        case .tvShows:
            return [.firstAirDate(.asc), .firstAirDate(.desc),
                    .name(.asc), .name(.desc),
                    .voteAverage(.asc), .voteAverage(.desc)]
        }
    }
    
    static func forRated(_ type: ContentsType) -> [Sort] {
        switch type {
        case .movies:
            return [.createdAt(.asc), .createdAt(.desc),
                    .releaseDate(.asc), .releaseDate(.desc),
                    .title(.asc), .title(.desc),
                    .voteAverage(.asc), .voteAverage(.desc)]
        case .tvShows:
            return [.firstAirDate(.asc), .firstAirDate(.desc),
                    .name(.asc), .name(.desc),
                    .voteAverage(.asc), .voteAverage(.desc)]
        }
    }
}

enum SortOrder: String {
    case asc
    case desc
}

enum ContentAction {
    case rate
    case favorite
    case watchlist
}
