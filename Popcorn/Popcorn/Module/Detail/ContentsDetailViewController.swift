//
//  ContentsDetailViewController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/11/25.
//

import UIKit

class ContentsDetailViewController: UIViewController {
    @IBOutlet private weak var backdropIv: UIImageView!
    @IBOutlet private weak var posterIv: UIImageView!
    @IBOutlet private weak var titleLb: UILabel!
    @IBOutlet private weak var originalTitleLb: UILabel!
    @IBOutlet private weak var genreLb: UILabel!
    @IBOutlet private weak var releaseDateLb: UILabel!
    @IBOutlet private weak var runtimeLb: UILabel!
    @IBOutlet private weak var voteAverageLb: UILabel!
    @IBOutlet private weak var voteCountLb: UILabel!
    @IBOutlet private weak var overviewLb: UILabel!
    
    var id: Int!
    var contents: Movie?
    
    convenience init(id: Int) {
        self.init()
        self.id = id
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        getMovies()
    }
    
    func setupUI() {
        DispatchQueue.main.async {
            // 상단 backdrop 이미지
            if let path = self.contents?.backdropPath, let url = URL(string: AppConstants.Domain.tmdbImage + path), self.backdropIv.image == nil {
                Nuke.loadImage(with: url, options: ImageLoadingOptions.fadeIn, into: self.backdropIv)
            }
            
            // poster 이미지
            if let path = self.contents?.posterPath, let url = URL(string: AppConstants.Domain.tmdbImage + path), self.posterIv.image == nil {
                Nuke.loadImage(with: url, options: ImageLoadingOptions.fadeIn, into: self.posterIv)
            }
            
            // 제목
            if let title = self.contents?.title {
                self.titleLb.text = title
            }
            
            // original 제목
            if let originalTitle = self.contents?.originalTitle {
                self.originalTitleLb.text = originalTitle
            }
            
            // 장르
            if let genres = self.contents?.genres {
                var genresStr = ""
                genres.compactMap { $0.name }.forEach {
                    if genresStr.isEmpty {
                        genresStr += $0
                    } else {
                        genresStr += (", " + $0)
                    }
                }
                
                self.genreLb.text = genresStr
            }
                    
            
            // 개봉일
            if let releaseDate = self.contents?.releaseDate {
                self.releaseDateLb.text = releaseDate
            }
            
            // 상영시간
            if let runtime = self.contents?.runtime {
                self.runtimeLb.text = "\(runtime)분"
            }
            
            // 평점
            if let voteAverage = self.contents?.voteAverage {
                self.voteAverageLb.text = "\(voteAverage)"
            }
            
            // 평가자수
            if let voteCount = self.contents?.voteCount {
                self.voteCountLb.text = "\(voteCount)"
            }
            
            // 줄거리
            if let overview = self.contents?.overview {
                self.overviewLb.text = overview
            }
        }
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
                self.setupUI()
            case .failure(let error):
                Log.d(error)
            }
            
        }
    }
    @IBAction func buttonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
