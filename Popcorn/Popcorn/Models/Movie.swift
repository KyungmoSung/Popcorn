//
//  Movie.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/29.
//

import Foundation

class Movie: Contents {
    var title: String!
    var originalTitle: String!
    var adult: Bool?
    var releaseDate: AnyValue?
    var video: Bool?
    var runtime: Int?
    var revenue: Int?
    var budget: Int?
        
    enum CodingKeys : String, CodingKey{
        case title
        case originalTitle = "original_title"
        case adult
        case releaseDate = "release_date"
        case video
        case runtime
        case revenue
        case budget
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        self.adult = try container.decodeIfPresent(Bool.self, forKey: .adult)
        self.releaseDate = try container.decodeIfPresent(AnyValue.self, forKey: .releaseDate)
        self.video = try container.decodeIfPresent(Bool.self, forKey: .video)
        self.runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
        self.revenue = try container.decodeIfPresent(Int.self, forKey: .revenue)
        self.budget = try container.decodeIfPresent(Int.self, forKey: .budget)

        try super.init(from: decoder)
    }
    
    override init(id: Int, isLoading: Bool) {
        super.init(id: id, isLoading: isLoading)
    }
    
    func filteredInfo() -> [DetailInfo] {
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
        
//        productionCountries
        
        return infoItems
    }
}
