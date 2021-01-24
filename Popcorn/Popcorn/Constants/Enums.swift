//
//  Enums.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/28.
//

import Foundation

protocol SectionType {
    var title: String { get }
}

struct Section {
    enum Home: Int, SectionType {
        case nowPlaying
        case popular
        case topRated
        case upcoming
        case none
        
        var title: String {
            switch self {
            case .nowPlaying:
                return "nowPlaying".localized
            case .popular:
                return "popular".localized
            case .topRated:
                return "topRated".localized
            case .upcoming:
                return "upcoming".localized
            case .none:
                return "none".localized
            }
        }
    }

    enum Detail: RawRepresentable, SectionType {
        typealias RawValue = Int
        
        case title(title: String, subTitle: String, voteAverage: Double, genres: [Genre])
        case detail
        case synopsis
        case image(tabs: [String])
        case video
        case credit
        case recommendation
        case similar
        case review
        
        var rawValue: Int {
            switch self {
            case .title:
                return 0
            case .detail:
                return 1
            case .synopsis:
                return 2
            case .image:
                return 3
            case .video:
                return 4
            case .credit:
                return 5
            case .recommendation:
                return 6
            case .similar:
                return 7
            case .review:
                return 8
            }
        }
        
        init?(rawValue: Int) {
            switch rawValue {
            case 0:
                self = .title(title: "", subTitle: "", voteAverage: 0, genres: [])
            case 1:
                self = .detail
            case 2:
                self = .synopsis
            case 3:
                self = .image(tabs: [])
            case 4:
                self = .video
            case 5:
                self = .credit
            case 6:
                self = .recommendation
            case 7:
                self = .similar
            case 8:
                self = .review
            default:
                return nil
            }
        }
        
        var title: String {
            switch self {
            case .title:
                return "title".localized
            case .detail:
                return "detail".localized
            case .synopsis:
                return "synopsis".localized
            case .image:
                return "image".localized
            case .video:
                return "video".localized
            case .credit:
                return "credit".localized
            case .recommendation:
                return "recommendation".localized
            case .similar:
                return "similar".localized
            case .review:
                return "review".localized
            }
        }
        
        var height: CGFloat {
            switch self {
            case .title:
                return 0
            case .detail:
                return 80
            case .synopsis:
                return 100
            case .image:
                return 160
            case .video:
                return 160
            case .credit:
                return 160
            case .recommendation:
                return 200
            case .similar:
                return 200
            case .review:
                return 250
            }
        }
    }
}

enum MediaType: String {
    case image
    case video
}

enum ImageType: Int, CaseIterable {
    case poster
    case backdrop
    
    var title: String {
        switch self {
        case .backdrop:
            return "배경"
        case .poster:
            return "포스터"
        }
    }
}
