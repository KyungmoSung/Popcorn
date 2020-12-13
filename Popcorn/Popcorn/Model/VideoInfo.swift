//
//  VideoInfo.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/13.
//

import Foundation

class VideoInfo: Codable {
    let id: String
    let iso_639_1: String
    let iso_3166_1: String
    let key: String
    let name: String
    let site: String
    let size: Int
    let type: String
}

extension VideoInfo: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? VideoInfo else {
            return false
        }

        return self.id == object.id
    }
}
