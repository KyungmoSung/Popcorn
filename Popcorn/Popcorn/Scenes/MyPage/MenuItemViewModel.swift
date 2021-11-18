//
//  MenuItemViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/11/10.
//

import UIKit

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
