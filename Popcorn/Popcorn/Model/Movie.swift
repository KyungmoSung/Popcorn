//
//  Movie.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/29.
//

import Foundation

class Movie: Loadingable, Codable {
    var posterPath: String?
    var adult: Bool!
    var overview: String!
    var tagline: String!
    var releaseDate: AnyValue!
    var genreIds: [Int]!
    var id: Int!
    var originalTitle: String!
    var originalLanguage: String!
//    let spokenLanguages: [ISO]!
//    let productionCountries: [ISO]!
//    let productionCompanies: [ProductionCompany]!
    var title: String!
    var backdropPath: String?
    var popularity: Double!
    var voteCount: Int!
    var video: Bool!
    var voteAverage: Double!
    var genres: [Genre]?
    var runtime: Int?
    var revenue: Int!
    var budget: Int!
    
    enum CodingKeys : String, CodingKey{
        case adult
        case overview
        case tagline
        case id
        case title
        case popularity
        case video
        case genres
        case runtime
        case revenue
        case budget
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
    
    init(id: Int, isLoading: Bool) {
        super.init()

        self.id = id
        self.isLoading = isLoading
    }
    
    func filteredInfo() -> [DetailInfo] {
        var infoItems: [DetailInfo] = []
        
        if let runtime = runtime {
            let hour = "\(runtime / 60)" + "hour".localized
            let minute = "\(runtime % 60)" + "minute".localized
            infoItems.append(DetailInfo(title: "runtime".localized, desc: "\(hour) \(minute)"))
        }
        
        if let releaseDate = releaseDate.stringValue {
            infoItems.append(DetailInfo(title: "releaseDate".localized, desc: releaseDate))
        }
        
        infoItems.append(DetailInfo(title: "originalLanguage".localized, desc: originalLanguage))
        
        if let popularity = popularity {
            infoItems.append(DetailInfo(title: "popularity".localized, desc: "\(Int(popularity)) 점"))
        }
        
        if let revenue = revenue, revenue > 0 {
            infoItems.append(DetailInfo(title: "revenue".localized, desc: revenue.asCurrencyFormat()))
        }
        
        if let budget = budget, budget > 0 {
            infoItems.append(DetailInfo(title: "budget".localized, desc: budget.asCurrencyFormat()))
        }
        
//        productionCountries
        
        return infoItems
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
