//
//  Config.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/02/16.
//

import Foundation

class Config {
    static let shared = Config()
    
    var language: Language = Language(code: .en)
    var region: Country = Country(code: .US)
    
    var allLanguages: [Language]?
    var allCountries: [Country]?

    private var allMovieGenres: [Genre]?
    private var allTvShowGenres: [Genre]?
        
    private init() {}
    
    var group = DispatchGroup()
    
    func fetch(completion: @escaping () -> Void) {
        completion()
//        fetchConfiguration()
//        fetchGenres()
//
//        // 모든 설정 요청들이 완료되면 completion 호출
//        group.notify(queue: DispatchQueue.global()) {
//            DispatchQueue.main.async {
//                completion()
//            }
//        }
    }
    
    func fetchConfiguration() {
        group.enter()
        APIManager.request(AppConstants.API.Configuration.getLanguages, method: .get, params: nil, responseType: [Language].self) { (result) in
            switch result {
            case .success(let languages):
                self.allLanguages = languages
            case .failure(let error):
                Log.d(error)
            }
            
            self.group.leave()
        }
        
        group.enter()
        APIManager.request(AppConstants.API.Configuration.getCountries, method: .get, params: nil, responseType: [Country].self) { (result) in
            switch result {
            case .success(let countries):
                self.allCountries = countries
            case .failure(let error):
                Log.d(error)
            }
            
            self.group.leave()
        }
    }
    
    func fetchGenres() {
        group.enter()
        APIManager.request(AppConstants.API.Genre.getMovieList, method: .get, params: nil, responseType: ListResponse.self) { (result) in
            switch result {
            case .success(let list):
                self.allMovieGenres = list.genres
            case .failure(let error):
                Log.d(error)
            }
            
            self.group.leave()
        }
        
        group.enter()
        APIManager.request(AppConstants.API.Genre.getTvList, method: .get, params: nil, responseType: ListResponse.self) { (result) in
            switch result {
            case .success(let list):
                self.allTvShowGenres = list.genres
            case .failure(let error):
                Log.d(error)
            }
            
            self.group.leave()
        }
    }
    
    func allGenres(for type: ContentsType) -> [Genre]? {
        switch type {
        case .movies:
            return allMovieGenres
        case .tvShows:
            return allTvShowGenres
        }
    }
}
