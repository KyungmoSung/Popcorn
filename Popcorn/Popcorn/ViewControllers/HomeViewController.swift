//
//  HomeViewController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/29.
//

import UIKit

class HomeViewController: BaseViewController {
    @IBOutlet weak var contentsCollectionView: UICollectionView!
    @IBOutlet weak var headerCollectionView: UICollectionView!
    
    lazy var contentsAdapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
        adapter.dataSource = self
        return adapter
    }()
    
    lazy var headerAdapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
        adapter.dataSource = self
        return adapter
    }()
    
    var selectedContentsType: ContentsType = .movies {
        didSet {
            var sectionTypes: [SectionType]
            var loadingDummyItems: [Contents]
            
            switch selectedContentsType {
            case .movies:
                sectionTypes = Section.Home.Movie.allCases
                loadingDummyItems = [Int](0...2).map{ Movie(id: $0, isLoading: true) }
            case .tvShows:
                sectionTypes = Section.Home.TVShow.allCases
                loadingDummyItems = [Int](0...2).map{ TVShow(id: $0, isLoading: true) }
            }
            
            sectionItems.removeAll()
            
            for sectionType in sectionTypes {
                sectionItems.append(SectionItem(sectionType, items: loadingDummyItems))
            }
            
            contentsAdapter.performUpdates(animated: true, completion: nil)
            
            requestContents(for: sectionTypes, page: 1)
        }
    }

    var sectionItems: [SectionItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation(title: "Popcorn🍿", navigationBar: false, tabBar: true)
        
        contentsAdapter.collectionView = contentsCollectionView
        headerAdapter.collectionView = headerCollectionView
        
        contentsCollectionView.contentInset = UIEdgeInsets(top: 66, left: 0, bottom: 0, right: 0)
        headerCollectionView.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)

        selectedContentsType = .movies
    }
    
    func requestContents(for sections: [SectionType], page: Int) {
        let params: [String: Any] = [
            "page": page
        ]
                
        for (index, section) in sections.enumerated() {
            var api: String!
            switch section {
            case let movieSection as Section.Home.Movie:
                switch movieSection {
                case .popular:
                    api = AppConstants.API.Movie.getPopular
                case .nowPlaying:
                    api = AppConstants.API.Movie.getNowPlaying
                case .upcoming:
                    api = AppConstants.API.Movie.getUpcoming
                case .topRated:
                    api = AppConstants.API.Movie.getTopRated
                }
                
                APIManager.request(api, method: .get, params: params, responseType: PageResponse<Movie>.self) { (result) in
                    switch result {
                    case .success(let response):
                        guard let items = response.results else {
                            return
                        }
                        
                        self.updateContents(items, at: index, page: page)
                    case .failure(let error):
                        Log.d(error)
                    }
                }
            case let tvShowSection as Section.Home.TVShow:
                switch tvShowSection {
                case .popular:
                    api = AppConstants.API.TVShow.getPopular
                case .tvAiringToday:
                    api = AppConstants.API.TVShow.getTvAiringToday
                case .tvOnTheAir:
                    api = AppConstants.API.TVShow.getTvOnTheAir
                case .topRated:
                    api = AppConstants.API.TVShow.getTopRated
                }
                
                APIManager.request(api, method: .get, params: params, responseType: PageResponse<TVShow>.self) { (result) in
                    switch result {
                    case .success(let response):
                        guard let items = response.results else {
                            return
                        }
                        
                        self.updateContents(items, at: index, page: page)
                    case .failure(let error):
                        Log.d(error)
                    }
                }
            default:
                return
            }
        }
    }
    
    func updateContents(_ contents: [Contents], at index: Int, page: Int) {
        let sectionItem = self.sectionItems[index]
            
        if page == 1 {
            sectionItem.items = contents
        } else {
            sectionItem.items.append(contentsOf: contents)
        }
        
        if let sc = self.contentsAdapter.sectionController(for: sectionItem) as? HomeHorizontalSectionController {
            sc.collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                batchContext.reload(sc)
            })
        }
    }
}

extension HomeViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        switch listAdapter {
        case contentsAdapter:
            return sectionItems
        case headerAdapter:
            return ContentsType.allCases.map{ $0.title as ListDiffable }
        default:
            return []
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch listAdapter {
        case contentsAdapter:
            return HomeHorizontalSectionController()
        case headerAdapter:
            return HeaderTitleSectionController(delegate: self)
        default:
            return ListSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension HomeViewController: HeaderTitleSectionDelegate {
    func didSelectHeaderTitle(index: Int) {
        guard let type = ContentsType(rawValue: index) else {
            return
        }
        
        selectedContentsType = type
        
        var objects = headerAdapter.objects()
        objects.remove(at: index)
        headerAdapter.reloadObjects(objects)
    }
}
