//
//  HomeViewController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/29.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        getMovies()
    }

    func getMovies() {
        let params: [String: Any] = [
            "api_key": AppConstants.Key.tmdb,
            "language": "ko",
            "page": 1
        ]
        APIManager.request(AppConstants.API.Movie.getPopular, method: .get, params: params, responseType: Response<Movie>.self .self) { (result) in
            switch result {
            case .success(let response):
                Log.d(response)
            case .failure(let error):
                Log.d(error)
            }
        }
    }
}
