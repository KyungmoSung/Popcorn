//
//  BackdropItemViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/11/03.
//

import Foundation

class BackdropItemViewModel: RowViewModel {
    let content: Content
    let title: String
    let subTitle: String?
    let voteAverage: String
    let backdropImgURL: URL?
    let backdropHeroId: String?
    
    init(with content: Content, heroID: String?) {
        self.content = content
        self.title = content.title
        self.backdropHeroId = heroID
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        
        switch (content.originalTitle, content.releaseDate?.dateValue()) {
        case let (.some(originalTitle), .some(releaseDate)):
            let year = dateFormatter.string(from: releaseDate)
            self.subTitle = year + " · " + originalTitle
        case let (.some(originalTitle), nil):
            self.subTitle = originalTitle
        case let (nil, .some(releaseDate)):
            let year = dateFormatter.string(from: releaseDate)
            self.subTitle = year
        case (nil, nil):
            self.subTitle = nil
        }
        
        if let voteAverage = content.voteAverage {
            self.voteAverage = "\(voteAverage)"
        } else {
            self.voteAverage = "-"
        }
        
        if let backdropPath = content.backdropPath, let url = URL(string: AppConstants.Domain.tmdbImage + backdropPath) {
            self.backdropImgURL = url
        } else {
            self.backdropImgURL = nil
        }
        
        super.init(identity: heroID ?? "")
    }
}
