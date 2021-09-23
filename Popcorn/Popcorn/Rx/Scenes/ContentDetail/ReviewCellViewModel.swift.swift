//
//  ReviewItemViewModel.swift
//  Popcorn
//
//  Created by Kyungmo on 2021/09/07.
//

import Foundation

final class ReviewItemViewModel: RowViewModel {
    let profileURL: URL?
    let name: String
    var contents: String
    var rate: Int?
    let date: String?
    
    init(with review: Review) {
        if let path = review.authorDetails.avatarPath {
            var fullPath = path.contains("http") ? path : AppConstants.Domain.tmdbImage + path
            
            if fullPath.starts(with: "/") {
                fullPath = fullPath.replacingCharacters(in: ...fullPath.startIndex, with: "")
            }

            self.profileURL = URL(string: fullPath)
        } else {
            self.profileURL = nil
        }
        
        self.name = review.author ?? review.authorDetails.username
        self.contents = review.content
        self.rate = review.authorDetails.rating
        
        if let dateStr = review.updatedAt ?? review.createdAt, let date = dateStr.dateValue(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"
            self.date = dateFormatter.string(from: date)
        } else {
            self.date = nil
        }
        
        super.init(identity: name)
    }
}
