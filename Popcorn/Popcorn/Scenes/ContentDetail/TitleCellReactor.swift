//
//  TitleCellReactor.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/02.
//

import Foundation
import RxSwift
import ReactorKit

final class TitleCellReactor: RowViewModel, Reactor {
    enum Action {
        case share
        case rating
        case completedRating
    }
    
    enum Mutation {
        case setRate(Double?)
    }
    
    struct State {
        let title: String
        let subTitle: String
        let voteAverage: String
        let voteCount: String
        var rate: String
        var rateTitle: String
    }
    
    private let content: Content
    private var rated: Double?
    private let coordinator: ContentDetailCoordinator
    private let networkService: TmdbService
    
    let initialState: State
    
    init(with content: Content, rated: Double?, networkService: TmdbService = TmdbAPI(), coordinator: ContentDetailCoordinator) {
        self.content = content
        self.rated = rated
        self.coordinator = coordinator
        self.networkService = networkService
        
        let releaseDate = content.releaseDate?.dateValue()
        let originalTitle = content.originalTitle
        
        let subTitle: String
        if let date = releaseDate, let originalTitle = originalTitle {
            subTitle = date.toString("yyyy") + " · " + originalTitle
        } else if let date = releaseDate {
            subTitle = date.toString("yyyy")
        } else if let originalTitle = originalTitle {
            subTitle = originalTitle
        } else {
            subTitle = "-"
        }
        
        let voteAverageStr: String
        if let voteAverage = content.voteAverage, voteAverage > 0 {
            voteAverageStr = "\(voteAverage)"
        } else {
            voteAverageStr = "-"
        }
        
        let voteCountStr: String
        if let voteCount = content.voteCount, voteCount > 0 {
            voteCountStr = "\(voteCount)"
        } else {
            voteCountStr = "-"
        }
        
        let rateStr: String
        let rateTitle: String
        if let rate = rated {
            rateStr = "\(rate)"
            rateTitle = "My Rate"
        } else {
            rateStr = ""
            rateTitle = "Rate"
        }
        
        self.initialState = State(title: content.title,
                             subTitle: subTitle,
                             voteAverage: voteAverageStr,
                             voteCount: voteCountStr,
                             rate: rateStr,
                             rateTitle: rateTitle)
        
        super.init(identity: "\(rated ?? 0)")
    }
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
//        case .completedRating(let rate):
//            return .just(Mutation.setRate(rate))
        case .rating:
            coordinator.showRatePopup(rated: rated) {
                self.action.onNext(.completedRating)
            }
            return .empty()
        case .completedRating:
            let sessionID = AuthManager.shared.auth?.sessionID
            
            return networkService.accountStates(sessionID: sessionID,
                                                type: content.contentType,
                                                id: content.id)
                .map { Mutation.setRate($0.rated) }
        case .share:
            var activityItems: [Any] = []

            if let posterPath = content.posterPath,
                let url = URL(string: AppConstants.Domain.tmdbImage + posterPath) {
                activityItems.append(url)
            }

            if let title = self.content.title {
                activityItems.append(title)
            }
            
            if let originalTitle = self.content.originalTitle, originalTitle != self.content.title {
                activityItems.append("(\(originalTitle))")
            }
            
            self.coordinator.showSharePopup(activityItems: activityItems)

            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .setRate(let rate):
            self.rated = rate
            
            var newState = state
            
            let rateStr: String
            let rateTitle: String
            if let rate = rate {
                rateStr = "\(rate)"
                rateTitle = "My Rate"
            } else {
                rateStr = ""
                rateTitle = "Rate"
            }
            
            newState.rate = rateStr
            newState.rateTitle = rateTitle
            
            return newState
        }
    }
//    let title: String
//    private let releaseDate: Date?
//    private let originalTitle: String?
//    private let voteAverage: Double?
//    let state: Observable<AccountStates>
    
//    var subTitle: String {
//        if let date = releaseDate, let originalTitle = originalTitle {
//            return date.toString("yyyy") + " · " + originalTitle
//        } else if let date = releaseDate {
//            return date.toString("yyyy")
//        } else if let originalTitle = originalTitle {
//            return originalTitle
//        } else {
//            return "-"
//        }
//    }
//
//    var voteAverageText: String {
//        if let voteAverage = voteAverage, voteAverage > 0 {
//            return "\(voteAverage)"
//        } else {
//            return "-"
//        }
//    }
    
//    init(with content: Content) {
//        self.title = content.title
//        self.releaseDate = content.releaseDate?.dateValue()
//        self.originalTitle = content.originalTitle
//        self.voteAverage = content.voteAverage
//
//        super.init(identity: title)
//    }
}
