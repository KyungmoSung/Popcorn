//
//  Enums.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/28.
//

import Foundation

struct Section {
    enum Home: String {
        case nowPlaying
        case popular
        case topRated
        case upcoming
        case none
        
        var title: String {
            return self.rawValue.localized
        }
    }

    enum Detail: Equatable {
        case title(title: String, subTitle: String, voteAverage: Double, genres: [Genre])
        case detail
        case synopsis
        case image(tabs: [String])
        case video
        case credit
        case recommendation
        case similar
        case review
        
        var sectionTitle: String? {
            switch self {
            case .title:
                return nil
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
