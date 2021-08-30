//
//  _Section.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/18.
//

import Foundation

protocol _SectionType {
    var title: String { get }
    var height: CGFloat { get }
    var expandable: Bool { get }
}

enum HomeSection: _SectionType {
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
    
    var height: CGFloat {
        return 200
    }
    
    var expandable: Bool {
        return true
    }
}
