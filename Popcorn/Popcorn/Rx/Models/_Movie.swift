//
//  Movie.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/29.
//

import Foundation

class _Movie: _Content {
    var adult: Bool?
    var video: Bool?
    var runtime: Int?
    var revenue: Int?
    var budget: Int?

    var reports: [Report] {
        var reports: [Report] = []

        if let runtime = runtime {
            let hour = "\(runtime / 60)" + "hour".localized
            let minute = "\(runtime % 60)" + "minute".localized
            reports.append(Report(title: "runtime".localized, content: "\(hour) \(minute)"))
        }

        if let releaseDate = releaseDate?.stringValue {
            reports.append(Report(title: "releaseDate".localized, content: releaseDate))
        }

        if let originalLanguage = originalLanguage {
            reports.append(Report(title: "originalLanguage".localized, content: originalLanguage.rawValue))
        }

        if let popularity = popularity {
            reports.append(Report(title: "popularity".localized, content: "\(Int(popularity)) 점"))
        }

        if let revenue = revenue, revenue > 0 {
            reports.append(Report(title: "revenue".localized, content: revenue.asCurrencyFormat()))
        }

        if let budget = budget, budget > 0 {
            reports.append(Report(title: "budget".localized, content: budget.asCurrencyFormat()))
        }

        return reports
    }
    
    enum CodingKeys : String, CodingKey{
        case title
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case adult
        case video
        case runtime
        case revenue
        case budget
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        self.releaseDate = try container.decodeIfPresent(AnyValue.self, forKey: .releaseDate)
        self.adult = try container.decodeIfPresent(Bool.self, forKey: .adult)
        self.video = try container.decodeIfPresent(Bool.self, forKey: .video)
        self.runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
        self.revenue = try container.decodeIfPresent(Int.self, forKey: .revenue)
        self.budget = try container.decodeIfPresent(Int.self, forKey: .budget)
    }
}
