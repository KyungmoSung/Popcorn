//
//  Media.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/13.
//

import Foundation

protocol Media {}

// MARK: - ImageInfo
class ImageInfo: Media, Codable {
    var type: ImageType!
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

// MARK: - VideoInfo
class VideoInfo: Media, Codable {
    let id: String
    let iso_639_1: String
    let iso_3166_1: String
    let key: String
    let name: String
    let site: String
    let size: Int
    let type: String
}
