//
//  TabCellViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/06.
//

import Foundation

final class TabCellViewModel: RowViewModel {
    let title: String
    let isSelected: Bool
    
    init(with title: String, isSelected: Bool) {
        self.title = title
        self.isSelected = isSelected
        
        super.init(identifier: title)
    }
}
