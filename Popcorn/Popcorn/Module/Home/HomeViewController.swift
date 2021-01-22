//
//  HomeViewController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/29.
//

import UIKit

class HomeViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        return adapter
    }()
    
    let homeSections: [Section.Home] = [.popular, .nowPlaying, .upcoming, .topRated]
    
    var contentsCollections: [ContentsCollection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation(title: "Popcorn🍿", navigationBar: false, tabBar: true)
        
        for homeSection in homeSections {
            var contents: [Movie] = []
            for i in 0...2 {
                contents.append(Movie(id: i, isLoading: true))
            }
            contentsCollections.append(ContentsCollection(homeSection: homeSection, contents: contents))
        }
        
        adapter.performUpdates(animated: true, completion: nil)

        getMovies(for: homeSections, page: 1)
    }
    
    func getMovies(for homeSections: [Section.Home], page: Int) {
        let params: [String: Any] = [
            "api_key": AppConstants.Key.tmdb,
            "language": "ko",
            "page": page
        ]
                
        for (index, homeSection) in homeSections.enumerated() {
            var api: String!
            switch homeSection {
            case .popular:
                api = AppConstants.API.Movie.getPopular
            case .nowPlaying:
                api = AppConstants.API.Movie.getNowPlaying
            case .upcoming:
                api = AppConstants.API.Movie.getUpcoming
            case .topRated:
                api = AppConstants.API.Movie.getTopRated
            case .none:
                return
            }
            
            APIManager.request(api, method: .get, params: params, responseType: PageResponse<Movie>.self .self) { (result) in
                
                let contentsCollection = self.contentsCollections[index]
                
                switch result {
                case .success(let response):
                    guard let contents = response.results else {
                        return
                    }
                    
                    if page == 1 {
                        contentsCollection.contents = contents
                    } else {
                        contentsCollection.contents.append(contentsOf: contents)
                    }
                case .failure(let error):
                    Log.d(error)
                }
                
                
                // 모든 요청이 완료되면 컬렉션뷰 업데이트
                if let sc = self.adapter.sectionController(for: contentsCollection) as? HorizontalSectionController {
                    sc.adapter.performUpdates(animated: true, completion: nil)
                }
            }
        }
    }
}

extension HomeViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return contentsCollections
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return HorizontalSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
