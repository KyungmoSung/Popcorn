//
//  TabCellViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/06.
//

import Foundation

final class TabCellViewModel: RowViewModelType {
    let title: String
    let isSelected: Bool
    
    init(with title: String, isSelected: Bool) {
        self.title = title
        self.isSelected = isSelected
    }
}

extension TabCellViewModel {
    typealias Identity = String
    
    var identity: Identity {
        return title
    }
    
    static func == (lhs: TabCellViewModel, rhs: TabCellViewModel) -> Bool {
        return lhs.title == rhs.title
    }
}
