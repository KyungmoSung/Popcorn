//
//  ReportItemViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/08.
//

import Foundation

final class ReportItemViewModel: RowViewModel {
    let title: String
    let content: String
    
    init(with report: Report) {
        self.title = report.title
        self.content = report.content
        
        super.init(identity: title)
    }
}
