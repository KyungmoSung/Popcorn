//
//  Informations.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/02.
//

import Foundation

struct Informations {
    enum Movie: Int, CaseIterable, _SectionType {
        case title
        case synopsis
        case credit
        case report
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
    
    enum TVShow: Int, CaseIterable, _SectionType {
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
    
    enum Person: Int, CaseIterable, _SectionType {
        case title
        case biography
        case detail
        case movies
        case tvShows
        case image
        
        var title: String? {
            switch self {
            case .title:
                return nil
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
        
        var expandable: Bool {
            return true
        }
    }
}
