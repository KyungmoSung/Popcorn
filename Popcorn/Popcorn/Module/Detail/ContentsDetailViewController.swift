//
//  ContentsDetailViewController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/11/25.
//

import UIKit

class ContentsDetailViewController: UIViewController {
    @IBOutlet private weak var backdropIv: UIImageView!
    
    var id: Int!
    var contents: Movie?
    
    convenience init(id: Int) {
        self.init()
        self.id = id
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getMovies()
        guard let path = contents?.backdropPath, let url = URL(string: AppConstants.Domain.tmdbImage + path) else {
                return
            }
            let options = ImageLoadingOptions(
                transition: .fadeIn(duration: 0.3)
            )
            Nuke.loadImage(with: url, options: options, into: backdropIv)
    }

    func getMovies() {
        let params: [String: Any] = [
            "api_key": AppConstants.Key.tmdb,
            "language": "ko",
            "page": 1,
            "region": "ko"
        ]
        
        APIManager.request(AppConstants.API.Movie.getDetails(id), method: .get, params: params, responseType: Movie.self .self) { (result) in
            
            switch result {
            case .success(let response):
                self.contents = response
            case .failure(let error):
                Log.d(error)
            }
            
        }
    }
    @IBAction func buttonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
