//
//  PosterItemViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/20.
//

import Foundation

final class PosterItemViewModel: RowViewModel {
    let content: Content
    let id: Int
    let title: String
    let voteAverage: String
    let posterHeroId: String?
    let posterImgURL: URL?
    
    init(with content: Content, heroID: String?) {
        self.content = content
        self.id = content.id
        self.title = content.title
        self.posterHeroId = heroID
        
        if let voteAverage = content.voteAverage {
            self.voteAverage = "\(voteAverage)"
        } else {
            self.voteAverage = "-"
        }
        
        if let posterPath = content.posterPath, let url = URL(string: AppConstants.Domain.tmdbImage + posterPath) {
            self.posterImgURL = url
        } else {
            self.posterImgURL = nil
        }
        
        super.init(identity: heroID ?? "")
    }
}
