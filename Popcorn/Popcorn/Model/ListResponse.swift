//
//  ListResponse.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/13.
//

import Foundation

struct ListResponse<T: Codable>: Codable {
    let id: Int
    let backdrops: [ImageInfo]?
    let posters: [ImageInfo]?
    let genres: [Genre]?
    let results: [T]?
}
