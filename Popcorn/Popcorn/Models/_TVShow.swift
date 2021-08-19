//
//  TVShow.swift
//  Popcorn
//
//  Created by Kyungmo on 2021/02/02.
//

import Foundation


// MARK: - Result
struct _TVShow: Codable, _Content {
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
    
    var originCountry: [ISO_3166_1]?
    var createdBy: [Person]?
    var episodeRunTime: [Int]?
    var inProduction: Bool?
    var languages: [String]?
    var firstAirDate: AnyValue?
    var lastAirDate: AnyValue?
    var lastEpisodeToAir: Episode?
    var nextEpisodeToAir: Episode?
    var networks: [Company]?
    var numberOfEpisodes: Int?
    var numberOfSeasons: Int?
    var seasons: [Season]?
    var status: String?
    var type: String?
    
    var isLoading: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "name"
        case originalTitle = "original_name"
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
        
        case originCountry = "origin_country"
        case createdBy = "created_by"
        case episodeRunTime = "episode_run_time"
        case inProduction = "in_production"
        case languages
        case firstAirDate = "first_air_date"
        case lastAirDate = "last_air_date"
        case lastEpisodeToAir = "last_episode_to_air"
        case nextEpisodeToAir = "next_episode_to_air"
        case networks
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case seasons
        case status
        case type
    }
    
    init(id: Int, isLoading: Bool) {
        self.id = id
        self.isLoading = isLoading
    }
    
    var detailInfos: [DetailInfo] {
        var infoItems: [DetailInfo] = []
        
        if let numberOfSeasons = numberOfSeasons {
            infoItems.append(DetailInfo(title: "numberOfSeasons".localized, desc: "\(numberOfSeasons) \("seasons".localized)"))
        }
        
        if let numberOfEpisodes = numberOfEpisodes {
            infoItems.append(DetailInfo(title: "numberOfEpisodes".localized, desc: "\(numberOfEpisodes) \("episodes".localized)"))
        }
        
        if let firstAirDate = firstAirDate?.stringValue {
            infoItems.append(DetailInfo(title: "firstAirDate".localized, desc: firstAirDate))
        }
        
        if let lastAirDate = lastAirDate?.stringValue {
            infoItems.append(DetailInfo(title: "lastAirDate".localized, desc: lastAirDate))
        }
        
        if let originalLanguage = originalLanguage {
            infoItems.append(DetailInfo(title: "originalLanguage".localized, desc: originalLanguage.rawValue))
        }
        
        if let popularity = popularity {
            infoItems.append(DetailInfo(title: "popularity".localized, desc: "\(Int(popularity)) 점"))
        }
        
        return infoItems
    }
}
