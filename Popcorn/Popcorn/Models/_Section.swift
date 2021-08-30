//
//  _Section.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/18.
//

import Foundation

struct _Section {
    enum Home: Equatable {
        case movie(MovieChart)
        case tvShow(TVShowChart)
        
        var title: String {
            switch self {
            case .movie(let chart):
                return chart.title
            case .tvShow(let chart):
                return chart.title
            }
        }
    }
}
