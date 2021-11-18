//
//  Menu.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/11/10.
//

import UIKit

enum Menu: String, CaseIterable {
    case favorite
    case watchlist
    case rated
    case signOut
    
    var title: String {
        switch self {
        case .favorite:
            return "favorite".localized
        case .watchlist:
            return "watchlist".localized
        case .rated:
            return "rated".localized
        case .signOut:
            return "signOut".localized
        }
    }
    
    var image: UIImage? {
        let imageName: String
        
        switch self {
        case .favorite:
            imageName = "icFavorite"
        case .watchlist:
            imageName = "icAddList"
        case .rated:
            imageName = "icStarBorder"
        case .signOut:
            imageName = "icStarBorder"
        }
        
        return UIImage(named: imageName)
    }
}

