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
    
    private init(){
        if let data = UserDefaults.standard.value(forKey:"auth") as? Data,
           let auth = try? PropertyListDecoder().decode(Auth.self, from: data) {
            authResultSubject.onNext(auth)
        }
        
        if let data = UserDefaults.standard.value(forKey:"user") as? Data,
           let user = try? PropertyListDecoder().decode(User.self, from: data) {
            profileResultSubject.onNext(user)
        }

        authResultSubject
            .subscribe(onNext: { auth in
                UserDefaults.standard.set(try? PropertyListEncoder().encode(auth), forKey:"auth")
            })
            .disposed(by: disposeBag)
        
        profileResultSubject
            .subscribe(onNext: { user in
                UserDefaults.standard.set(try? PropertyListEncoder().encode(user), forKey:"user")
            })
            .disposed(by: disposeBag)
    }
    
    var disposeBag = DisposeBag()
    var networkService: TmdbService = TmdbAPI()
    let activityIndicator = ActivityIndicator()
    let errorTracker = ErrorTracker()
    
    var authResultSubject = BehaviorSubject<Auth?>(value: nil)
    var auth: Auth? {
        return try? authResultSubject.value()
    }
    
    var profileResultSubject = BehaviorSubject<User?>(value: nil)
    var user: User? {
        return try? profileResultSubject.value()
    }
    
    var signResult: Observable<Bool> {
        return Observable.combineLatest(authResultSubject, profileResultSubject)
            .map { auth, user in
                if let _ = auth, let _ = user {
                    return true
                } else {
                    return false
                }
            }
    }
    
    private func createRequestToken() -> Observable<String> {
        return networkService.createRequestToken()
            .compactMap{ $0.requestToken }
            .do(onNext: { requestToken in
                var currentAuth = self.auth ?? Auth()
                currentAuth.requestToken = requestToken
                self.authResultSubject.onNext(currentAuth)
            })
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
    }
    
    private func createAccessToken(requestToken: String) -> Observable<String> {
        return networkService.createAccessToken(requestToken: requestToken)
            .map { ($0.accessToken, $0.accountID) }
            .do(onNext: { accessToken, accountID in
                var currentAuth = self.auth
                currentAuth?.accessToken = accessToken
                currentAuth?.accountID = accountID
                self.authResultSubject.onNext(currentAuth)
            })
            .compactMap{ $0.0 }
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
    }
    
    private func createSessionID(accessToken: String) -> Observable<String> {
        return networkService.createSession(accessToken: accessToken)
            .compactMap{ $0.sessionID }
            .do(onNext: { sessionID in
                var currentAuth = self.auth
                currentAuth?.sessionID = sessionID
                self.authResultSubject.onNext(currentAuth)
            })
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
    }
    
    private func getProfile(sessionID: String) -> Observable<User> {
        return networkService.accountProfile(sessionID: sessionID)
            .do(onNext: { user in
                self.profileResultSubject.onNext(user)
            })
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
    }
 
    /**
     Safari로 TMDB 로그인 사이트 이동
     - requestToken(v4) 생성 후 TMDB URL에 Token 추가
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
        guard let requestToken = auth?.requestToken else { return Observable.error(AuthError.invalideRequestToken)}
        
        return createAccessToken(requestToken: requestToken)
            .flatMap({ accessToken in
                self.createSessionID(accessToken: accessToken)
            })
            .flatMap({ sessionID in
                self.getProfile(sessionID: sessionID)
            })
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
    }
    
    func isSignIn() -> Bool {
        let auth = try? authResultSubject.value()
        let user = try? profileResultSubject.value()
        return auth != nil && user != nil
    }
    
    func signOut() {
        authResultSubject.onNext(nil)
        profileResultSubject.onNext(nil)
    }
}

enum AuthError: Error {
    case notSignIn
    case invalideRequestToken
    case server(msg: String)
}
