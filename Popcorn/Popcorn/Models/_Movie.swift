//
//  Movie.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/29.
//

import Foundation

struct _Movie: Codable, _Content {
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
    
    var adult: Bool?
    var releaseDate: AnyValue?
    var video: Bool?
    var runtime: Int?
    var revenue: Int?
    var budget: Int?
    
    var isLoading: Bool = false

    enum CodingKeys : String, CodingKey{
        case id
        case title
        case originalTitle = "original_title"
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
        
        case adult
        case releaseDate = "release_date"
        case video
        case runtime
        case revenue
        case budget
    }
    
    init(id: Int, isLoading: Bool) {
        self.id = id
        self.isLoading = isLoading
    }
    
    var detailInfos: [DetailInfo] {
        var infoItems: [DetailInfo] = []
        
        if let runtime = runtime {
            let hour = "\(runtime / 60)" + "hour".localized
            let minute = "\(runtime % 60)" + "minute".localized
            infoItems.append(DetailInfo(title: "runtime".localized, desc: "\(hour) \(minute)"))
        }
        
        if let releaseDate = releaseDate?.stringValue {
            infoItems.append(DetailInfo(title: "releaseDate".localized, desc: releaseDate))
        }
        
        if let originalLanguage = originalLanguage {
            infoItems.append(DetailInfo(title: "originalLanguage".localized, desc: originalLanguage.rawValue))
        }
        
        if let popularity = popularity {
            infoItems.append(DetailInfo(title: "popularity".localized, desc: "\(Int(popularity)) 점"))
        }
        
        if let revenue = revenue, revenue > 0 {
            infoItems.append(DetailInfo(title: "revenue".localized, desc: revenue.asCurrencyFormat()))
        }
        
        if let budget = budget, budget > 0 {
            infoItems.append(DetailInfo(title: "budget".localized, desc: budget.asCurrencyFormat()))
        }
                
        return infoItems
    }
}
