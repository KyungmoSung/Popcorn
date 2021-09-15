//
//  ReportCellViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/08.
//

import Foundation

final class ReportCellViewModel: RowViewModelType {
    let title: String
    let content: String
    
    init(with report: Report) {
        self.title = report.title
        self.content = report.content
    }
}

extension ReportCellViewModel {
    typealias Identity = String
    
    var identity: Identity {
        return title
    }
    
    static func == (lhs: ReportCellViewModel, rhs: ReportCellViewModel) -> Bool {
        return lhs.title == rhs.title
    }
}