//
//  Image.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/13.
//

import Foundation

class ImageInfo: Codable {
    let aspectRatio: Double
    let filePath: String
    let height: Int
    let iso639_1: String?
    let voteAverage: Double
    let voteCount, width: Int

    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case filePath = "file_path"
        case height
        case iso639_1 = "iso_639_1"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case width
    }
}

extension ImageInfo: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return filePath as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? ImageInfo else {
            return false
        }

        return self.filePath == object.filePath
    }
}
