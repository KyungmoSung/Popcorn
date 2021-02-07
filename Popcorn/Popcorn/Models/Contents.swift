//
//  Contents.swift
//  Popcorn
//
//  Created by Kyungmo on 2021/02/02.
//

import Foundation


// MARK: - Result
class Contents: Loadingable, Codable {
    var id: Int
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

    var isLoading: Bool = false

    enum CodingKeys: String, CodingKey {
        case id
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

extension Contents: Equatable, ListDiffable {
    static func == (lhs: Contents, rhs: Contents) -> Bool {
        return lhs.id == rhs.id
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? Contents else {
            return false
        }
        
        guard self.posterPath == object.posterPath else {
            return false
        }
        
        guard self.backdropPath == object.backdropPath else {
            return false
        }
        
        guard self.id == object.id else {
            return false
        }
        
        return true
    }
}
