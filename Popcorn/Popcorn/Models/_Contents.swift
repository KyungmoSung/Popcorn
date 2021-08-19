//
//  Contents.swift
//  Popcorn
//
//  Created by Kyungmo on 2021/02/02.
//

import Foundation

protocol _Content: Loadingable {
    var id: Int { get set }
    var title: String! { get set }
    var originalTitle: String! { get set }
    var overview: String? { get set }
    var tagline: String? { get set }
    var genres: [Genre]? { get set }
    var genreIDS: [Int]? { get set }
    var popularity: Double? { get set }
    var posterPath: String? { get set }
    var backdropPath: String? { get set }
    var homepage: String? { get set }
    var voteAverage: Double? { get set }
    var voteCount: Int? { get set }
    var originalLanguage: ISO_639_1? { get set }
    var spokenLanguages: [Language]? { get set }
    var productionCountries: [Country]? { get set }
    var productionCompanies: [Company]? { get set }
}
