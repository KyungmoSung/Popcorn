//
//  PosterViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/20.
//

import Foundation

final class PosterViewModel {
    let id: Int
    let title:String
    let posterImgPath : String?
    let posterHeroId: String?
    let voteAverage: Double?
    
    init(with content: _Content, heroID: String?) {
        self.id = content.id
        self.title = content.title
        self.posterImgPath = content.posterPath
        self.voteAverage = content.voteAverage
        self.posterHeroId = heroID
    }
}
