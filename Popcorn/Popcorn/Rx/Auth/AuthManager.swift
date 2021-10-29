//
//  AuthManager.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/10/28.
//

import Foundation
import RxSwift

class AuthManager {
    static let shared = AuthManager()
//    static let currentUser = User()

    private init(){}
    
    var disposeBag = DisposeBag()
    var networkService: TmdbService = TmdbAPI()
    let activityIndicator = ActivityIndicator()
    let errorTracker = ErrorTracker()
    
    var accountID: String?
    var requestToken: String?
    var accessToken: String?
    
    private func createRequestToken() -> Observable<String> {
        return networkService.createRequestToken()
            .map{ auth in
                self.requestToken = auth.requestToken
                return auth.requestToken
            }
            .compactMap{ $0 }
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
    }
    
    private func createAccessToken() -> Observable<Bool> {
        guard let requestToken = requestToken else {
            return Observable.just(false)
        }
        
        return networkService.createAccessToken(requestToken: requestToken)
            .map { auth in
                if let accessToken = auth.accessToken,
                   let accountID = auth.accountID {
                    self.accessToken = accessToken
                    self.accountID = accountID
                    return true
                } else {
                    return false
                }
            }
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
    }
    
    
    func openSignURL(with requestToken: String) {
        createRequestToken()
            .subscribe(onNext: { requestToken in
                var component = URLComponents(string: AppConstants.Domain.tmdbAuth)
                let requestTokenQuery = URLQueryItem(name: "request_token", value: requestToken)
                component?.queryItems = [requestTokenQuery]
                
                if let url = component?.url {
                    UIApplication.shared.open(url, options: [:])
                }
            })
            .disposed(by: disposeBag)
    }
}
