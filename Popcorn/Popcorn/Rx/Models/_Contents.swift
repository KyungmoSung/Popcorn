//
//  Contents.swift
//  Popcorn
//
//  Created by Kyungmo on 2021/02/02.
//

import Foundation

class _Content: Codable, Loadingable {
    var id: Int
    var title: String!
    var originalTitle: String!
    var overview: String?
    var tagline: String?
    var genres: [Genre]?
    var genreIDS: [Int]?
    var popularity: Double?
    var posterPath: String?
    var backdropPath: String?
    var homepage: String?
    var voteAverage: Double?
    var voteCount: Int?
    var originalLanguage: ISO_639_1?
    var spokenLanguages: [Language]?
    var productionCountries: [Country]?
    var productionCompanies: [Company]?
    var releaseDate: AnyValue?
    
    var isLoading: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle
        case overview
        case tagline
        case genres
        case genreIDS = "genre_ids"
        case popularity
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case homepage
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case originalLanguage = "original_language"
        case spokenLanguages = "spoken_languages"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
    }
    
    init(id: Int, isLoading: Bool) {
        self.id = id
        self.isLoading = isLoading
    }
}
