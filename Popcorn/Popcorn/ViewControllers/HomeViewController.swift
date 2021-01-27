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
    
    var sectionItems: [HomeSectionItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation(title: "Popcorn🍿", navigationBar: false, tabBar: true)
        
        for homeSection in homeSections {
            var items: [Movie] = []
            for i in 0...2 {
                items.append(Movie(id: i, isLoading: true))
            }
            sectionItems.append(HomeSectionItem(homeSection, items: items))
        }
        
        adapter.performUpdates(animated: true, completion: nil)

        getMovies(for: homeSections, page: 1)
    }
    
    func getMovies(for homeSections: [Section.Home], page: Int) {
        let params: [String: Any] = [
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
                
                let sectionItem = self.sectionItems[index]
                
                switch result {
                case .success(let response):
                    guard let item = response.results else {
                        return
                    }
                    
                    if page == 1 {
                        sectionItem.items = item
                    } else {
                        sectionItem.items.append(contentsOf: item)
                    }
                case .failure(let error):
                    Log.d(error)
                }
                
                
                // 모든 요청이 완료되면 컬렉션뷰 업데이트
                if let sc = self.adapter.sectionController(for: sectionItem) as? HomeHorizontalSectionController {
                    sc.adapter.performUpdates(animated: true, completion: nil)
                }
            }
        }
    }
}

extension HomeViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return sectionItems
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return HomeHorizontalSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
