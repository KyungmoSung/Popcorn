//
//  SynopsisItemViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/09.
//

import Foundation

final class SynopsisItemViewModel: RowViewModel {
    let synopsis: String
    let isTagline: Bool
    
    init(with synopsis: String, isTagline: Bool) {
        self.synopsis = synopsis
        self.isTagline = isTagline
        
        super.init(identity: synopsis)
    }
}
