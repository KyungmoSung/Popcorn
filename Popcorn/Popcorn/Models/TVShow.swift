//
//  TVShow.swift
//  Popcorn
//
//  Created by Kyungmo on 2021/02/02.
//

import Foundation


// MARK: - Result
class TVShow: Contents {
    var name: String!
    var originalName: String!
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
    
    enum CodingKeys: String, CodingKey {
        case name
        case originalName = "original_name"
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
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.originalName = try container.decodeIfPresent(String.self, forKey: .originalName)
        self.originCountry = try container.decodeIfPresent([ISO_3166_1].self, forKey: .originCountry)
        self.createdBy = try container.decodeIfPresent([Person].self, forKey: .createdBy)
        self.episodeRunTime = try container.decodeIfPresent([Int].self, forKey: .episodeRunTime)
        self.inProduction = try container.decodeIfPresent(Bool.self, forKey: .inProduction)
        self.languages = try container.decodeIfPresent([String].self, forKey: .languages)
        self.firstAirDate = try container.decodeIfPresent(AnyValue.self, forKey: .firstAirDate)
        self.lastAirDate = try container.decodeIfPresent(AnyValue.self, forKey: .lastAirDate)
        self.lastEpisodeToAir = try container.decodeIfPresent(Episode.self, forKey: .lastEpisodeToAir)
        self.nextEpisodeToAir = try container.decodeIfPresent(Episode.self, forKey: .nextEpisodeToAir)
        self.networks = try container.decodeIfPresent([Company].self, forKey: .networks)
        self.numberOfEpisodes = try container.decodeIfPresent(Int.self, forKey: .numberOfEpisodes)
        self.numberOfSeasons = try container.decodeIfPresent(Int.self, forKey: .numberOfSeasons)
        self.seasons = try container.decodeIfPresent([Season].self, forKey: .seasons)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        
        try super.init(from: decoder)
    }
    
    override init(id: Int, isLoading: Bool) {
        super.init(id: id, isLoading: isLoading)
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
