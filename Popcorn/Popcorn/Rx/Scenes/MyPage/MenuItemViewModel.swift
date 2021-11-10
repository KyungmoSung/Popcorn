//
//  MenuItemViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/11/10.
//

import Foundation

final class MenuItemViewModel: RowViewModel {
    let menu: Menu
    let image: UIImage?
    let title: String
    
    init(menu: Menu) {
        self.menu = menu
        self.image = menu.image
        self.title = menu.title
        
        super.init(identity: self.title)
    }
}

enum Menu: String, CaseIterable {
    case favorite
    case watchlist
    case rated
    
    var title: String {
        switch self {
        case .favorite:
            return "favorite".localized
        case .watchlist:
            return "watchlist".localized
        case .rated:
            return "rated".localized
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
        }
        
        return UIImage(named: imageName)
    }
}
