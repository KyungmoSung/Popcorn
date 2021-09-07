//
//  CreditCellViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/02.
//

import Foundation

final class CreditCellViewModel: RowViewModel {
    let name: String
    let job: String?
    let profileURL: URL?
    
    init(with person: Person) {
        self.name = person.name
        
        if let cast = person as? Cast {
            self.job = cast.character
        } else if let crew = person as? Crew {
            self.job = crew.job
        } else {
            self.job = nil
        }
        
        if let path = person.profilePath, let url = URL(string: AppConstants.Domain.tmdbImage + path) {
            self.profileURL = url
        } else {
            self.profileURL = nil
        }
    }
}
