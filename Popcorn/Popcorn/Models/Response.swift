//
//  PageResponse.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/29.
//

import Foundation

struct Response<T: Codable>: Codable {
    let results: [T]?
}

struct PageResponse<T: Codable>: Codable {
    let page: Int?
    let results: [T]?
    let totalResults: Int?
    let totalPages: Int?
    
    enum CodingKeys : String, CodingKey{
        case page
        case results
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}

struct ListResponse: Codable {
    let id: Int?
    let backdrops: [ImageInfo]?
    let posters: [ImageInfo]?
    let genres: [Genre]?
    let cast: [Cast]?
    let crew: [Crew]?
}
