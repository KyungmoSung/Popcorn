//
//  TVShow.swift
//  Popcorn
//
//  Created by Kyungmo on 2021/02/02.
//

import Foundation

class TVShow: Content {
    var originCountry: [ISO_3166_1]?
    var createdBy: [Person]?
    var episodeRunTime: [Int]?
    var inProduction: Bool?
    var languages: [String]?
    var lastAirDate: AnyValue?
    var lastEpisodeToAir: Episode?
    var nextEpisodeToAir: Episode?
    var networks: [Company]?
    var numberOfEpisodes: Int?
    var numberOfSeasons: Int?
    var seasons: [Season]?
    var status: String?
    var type: String?
    
    var reports: [Report] {
        var reports: [Report] = []

        if let numberOfSeasons = numberOfSeasons {
            reports.append(Report(title: "numberOfSeasons".localized, content: "\(numberOfSeasons) \("seasons".localized)"))
        }

        if let numberOfEpisodes = numberOfEpisodes {
            reports.append(Report(title: "numberOfEpisodes".localized, content: "\(numberOfEpisodes) \("episodes".localized)"))
        }

        if let firstAirDate = releaseDate?.stringValue {
            reports.append(Report(title: "firstAirDate".localized, content: firstAirDate))
        }

        if let lastAirDate = lastAirDate?.stringValue {
            reports.append(Report(title: "lastAirDate".localized, content: lastAirDate))
        }

        if let originalLanguage = originalLanguage {
            reports.append(Report(title: "originalLanguage".localized, content: originalLanguage.rawValue))
        }

        if let popularity = popularity {
            reports.append(Report(title: "popularity".localized, content: "\(Int(popularity)) 점"))
        }

        return reports
    }
    
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
        case releaseDate = "first_air_date"
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
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        self.originCountry = try container.decodeIfPresent([ISO_3166_1].self, forKey: .originCountry)
        self.createdBy = try container.decodeIfPresent([Person].self, forKey: .createdBy)
        self.episodeRunTime = try container.decodeIfPresent([Int].self, forKey: .episodeRunTime)
        self.inProduction = try container.decodeIfPresent(Bool.self, forKey: .inProduction)
        self.languages = try container.decodeIfPresent([String].self, forKey: .languages)
        self.releaseDate = try container.decodeIfPresent(AnyValue.self, forKey: .releaseDate)
        self.lastAirDate = try container.decodeIfPresent(AnyValue.self, forKey: .lastAirDate)
        self.lastEpisodeToAir = try container.decodeIfPresent(Episode.self, forKey: .lastEpisodeToAir)
        self.nextEpisodeToAir = try container.decodeIfPresent(Episode.self, forKey: .nextEpisodeToAir)
        self.networks = try container.decodeIfPresent([Company].self, forKey: .networks)
        self.numberOfEpisodes = try container.decodeIfPresent(Int.self, forKey: .numberOfEpisodes)
        self.numberOfSeasons = try container.decodeIfPresent(Int.self, forKey: .numberOfSeasons)
        self.seasons = try container.decodeIfPresent([Season].self, forKey: .seasons)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
    }
}

// MARK: - Episode
struct Episode: Codable {
    var airDate: String?
    var episodeNumber: Int?
    var id: Int?
    var name: String?
    var overview: String?
    var productionCode: String?
    var seasonNumber: Int?
    var stillPath: String?
    var voteAverage: Double?
    var voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case id = "id"
        case name = "name"
        case overview = "overview"
        case productionCode = "production_code"
        case seasonNumber = "season_number"
        case stillPath = "still_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - Season
struct Season: Codable {
    var airDate: String?
    var episodeCount: Int?
    var id: Int?
    var name: String?
    var overview: String?
    var posterPath: String?
    var seasonNumber: Int?

    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeCount = "episode_count"
        case id = "id"
        case name = "name"
        case overview = "overview"
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
    }
}
