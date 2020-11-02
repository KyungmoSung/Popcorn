//
//  HomeViewController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/29.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    var contentsCollections: [ContentsCollection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
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
                guard let contents = response.results else {
                    return
                }
                let contentsCollection = ContentsCollection(category: .popular, contents: contents)
                self.contentsCollections.append(ContentsCollection(category: .popular, contents: contents))
                self.contentsCollections.append(ContentsCollection(category: .latest, contents: contents))
                self.contentsCollections.append(ContentsCollection(category: .topRated, contents: contents))
                self.contentsCollections.append(ContentsCollection(category: .upcoming, contents: contents))
                self.contentsCollections.append(ContentsCollection(category: .popular, contents: contents))
                self.contentsCollections.append(ContentsCollection(category: .nowPlaying, contents: contents))
                self.adapter.performUpdates(animated: true, completion: nil)
                Log.d(response)
            case .failure(let error):
                Log.d(error)
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
