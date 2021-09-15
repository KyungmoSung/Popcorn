//
//  PosterItemViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/20.
//

import Foundation
import RxDataSources

final class PosterItemViewModel: RowViewModelType {
    let content: _Content
    let id: Int
    let title:String
    let posterImgPath : String?
    let posterHeroId: String?
    let voteAverage: Double?
    
    init(with content: _Content, heroID: String?) {
        self.content = content
        self.id = content.id
        self.title = content.title
        self.posterImgPath = content.posterPath
        self.voteAverage = content.voteAverage
        self.posterHeroId = heroID
    }
}

extension PosterItemViewModel {
    typealias Identity = Int
    
    var identity: Identity {
        return id
    }
    
    static func == (lhs: PosterItemViewModel, rhs: PosterItemViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
