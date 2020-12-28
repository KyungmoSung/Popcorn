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

    enum Detail: String, CaseIterable {
        case genre
        case detail
        case synopsis
        case image
        case video
        case credit
        case recommendation
        case similar
        case review
        
        var title: String {
            return self.rawValue.localized
        }
        
        var height: CGFloat {
            switch self {
            case .genre:
                return 30
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

enum ImageType: String {
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
