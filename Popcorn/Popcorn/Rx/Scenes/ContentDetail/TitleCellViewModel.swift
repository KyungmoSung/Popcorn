//
//  TitleCellViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/02.
//

import Foundation

final class TitleCellViewModel: RowViewModel {
    let title: String
    private let releaseDate: Date?
    private let originalTitle: String?
    private let voteAverage: Double?
    
    var subTitle: String {
        if let date = releaseDate, let originalTitle = originalTitle {
            return date.toString("yyyy") + " · " + originalTitle
        } else if let date = releaseDate {
            return date.toString("yyyy")
        } else if let originalTitle = originalTitle {
            return originalTitle
        } else {
            return "-"
        }
    }
    
    var voteAverageText: String {
        if let voteAverage = voteAverage, voteAverage > 0 {
            return "\(voteAverage)"
        } else {
            return "-"
        }
    }
    
    init(with content: _Content) {
        self.title = content.title
        self.releaseDate = content.releaseDate?.dateValue()
        self.originalTitle = content.originalTitle
        self.voteAverage = content.voteAverage
        
        super.init(identity: title)
    }
}
