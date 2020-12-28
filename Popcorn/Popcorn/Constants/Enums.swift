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

    enum Detail: String {
        case detail
        case synopsis
        case media
        case credit
        case recommendation
        case similar
        case review
        
        var title: String {
            return self.rawValue.localized
        }
    }
}
