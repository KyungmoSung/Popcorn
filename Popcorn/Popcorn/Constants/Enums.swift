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
    enum Home: String, SectionType {        
        case nowPlaying
        case popular
        case topRated
        case upcoming
        case none
        
        var title: String {
            return self.rawValue.localized
        }
    }

    enum Detail: RawRepresentable, SectionType {
        typealias RawValue = String
        
        case title(title: String, subTitle: String, voteAverage: Double, genres: [Genre])
        case detail
        case synopsis
        case image(tabs: [String])
        case video
        case credit
        case recommendation
        case similar
        case review
        
        var rawValue: String {
            switch self {
            case .title:
                return "title"
            case .detail:
                return "detail"
            case .synopsis:
                return "synopsis"
            case .image:
                return "image"
            case .video:
                return "video"
            case .credit:
                return "credit"
            case .recommendation:
                return "recommendation"
            case .similar:
                return "similar"
            case .review:
                return "review"
            }
        }
        
        init?(rawValue: String) {
            switch rawValue {
            case "title":
                self = .title(title: "", subTitle: "", voteAverage: 0, genres: [])
            case "detail":
                self = .detail
            case "synopsis":
                self = .synopsis
            case "image":
                self = .image(tabs: [])
            case "video":
                self = .video
            case "credit":
                self = .credit
            case "recommendation":
                self = .recommendation
            case "similar":
                self = .similar
            case "review":
                self = .review
            default:
                return nil
            }
        }
        
        var title: String {
            return self.rawValue.localized
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

enum ImageType: Int, CaseIterable, SectionType {
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
