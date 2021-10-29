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
    
    private init(){}
    
    var disposeBag = DisposeBag()
    var networkService: TmdbService = TmdbAPI()
    let activityIndicator = ActivityIndicator()
    let errorTracker = ErrorTracker()
    
    var user: User?
    var accountID: String?
    var requestToken: String?
    var accessToken: String?
    var sessionID: String?
    
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
    
    private func createAccessToken(requestToken: String) -> Observable<String> {
        return networkService.createAccessToken(requestToken: requestToken)
            .map { auth in
                self.accountID = auth.accountID
                self.accessToken = auth.accessToken
                return auth.accessToken
            }
            .compactMap{ $0 }
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
    }
    
    private func createSessionID(accessToken: String) -> Observable<String> {
        return networkService.createSession(accessToken: accessToken)
            .map { auth in
                self.sessionID = auth.sessionID
                return auth.sessionID
            }
            .compactMap{ $0 }
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
    }
    
    private func getProfile(sessionID: String) -> Observable<User> {
        return networkService.profile(sessionID: sessionID)
            .do(onNext: { user in
                self.user = user
            })
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
    }
    
    /**
     1. requestToken(v4) 생성 후 TMDB URL에 Token 추가
     2. Safari로 TMDB 로그인 사이트 이동
     */
    func openSignURL() {
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
    
    /**
     `openSignURL()` 호출하여 로그인 완료 후 accessToken, sessionID,  프로필 요청
     1. redirectURL로 App scheme 호출 완료 후
     2. 인증받은 requestToken(v4)으로 accessToken(v4) 생성
     3.  accessToken(v4)으로 sessionID(v3) 생성
     4. sessionID(v3)로 유저 프로필 요청
     */
    func requestSignIn() -> Observable<User> {
        guard let requestToken = requestToken else { return Observable.error(AuthError(msg: "invalide requestToken"))}
        
        return createAccessToken(requestToken: requestToken)
            .flatMap({ accessToken in
                self.createSessionID(accessToken: accessToken)
            })
            .flatMap({ sessionID in
                self.getProfile(sessionID: sessionID)
            })
            .map({ user in
                self.user = user
                return user
            })
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
    }
}

struct AuthError: Error {
    var msg: String
}
