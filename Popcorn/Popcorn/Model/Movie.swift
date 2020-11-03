//
//  Movie.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/29.
//

import Foundation

class Movie: Codable {
    
    let posterPath: String?
    let adult: Bool!
    let overview: String!
    let releaseDate: String!
    let genreIds: [Int]!
    let id: Int!
    let originalTitle: String!
    let originalLanguage: String!
//    let spokenLanguages: [ISO]!
//    let productionCountries: [ISO]!
//    let productionCompanies: [ProductionCompany]!
    let title: String!
    let backdropPath: String?
    let popularity: Double!
    let voteCount: Int!
    let video: Bool!
    let voteAverage: Double!
//    let genres: [Genre]!
    let runtime: Int?
    let revenue: Int!
    
    enum CodingKeys : String, CodingKey{
        case adult
        case overview
        case id
        case title
        case popularity
        case video
//        case genres
        case runtime
        case revenue
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
//        case spokenLanguages = "spoken_languages"
//        case productionCountries = "production_countries"
//        case productionCompanies = "production_companies"
        case backdropPath = "backdrop_path"
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
    }
}



extension Movie: Equatable, ListDiffable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Movie else {
            return false
        }

        return self.id == object.id
    }
}
