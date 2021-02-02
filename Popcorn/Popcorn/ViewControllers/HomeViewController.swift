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
    
    var selectedContentsType: ContentsType = .movies

    var homeSectionItems: [HomeSectionItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation(title: "Popcorn🍿", navigationBar: false, tabBar: true)
        
        contentsAdapter.collectionView = contentsCollectionView
        headerAdapter.collectionView = headerCollectionView
        contentsCollectionView.contentInset = UIEdgeInsets(top: 66, left: 0, bottom: 0, right: 0)
        headerCollectionView.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)

        for section in Section.Home.allCases {
            let items: [ListDiffable] = [Int](0...2).map{ Movie(id: $0, isLoading: true) }
            homeSectionItems.append(HomeSectionItem(section, items: items))
        }
        
        contentsAdapter.performUpdates(animated: true, completion: nil)

        getMovies(for: Section.Home.allCases, page: 1)
    }
    
    func getMovies(for sections: [Section.Home], page: Int) {
        let params: [String: Any] = [
            "page": page
        ]
                
        for (index, sections) in sections.enumerated() {
            var api: String!
            switch sections {
            case .popular:
                api = AppConstants.API.Movie.getPopular
            case .nowPlaying:
                api = AppConstants.API.Movie.getNowPlaying
            case .upcoming:
                api = AppConstants.API.Movie.getUpcoming
            case .topRated:
                api = AppConstants.API.Movie.getTopRated
            }
            
            APIManager.request(api, method: .get, params: params, responseType: PageResponse<Movie>.self .self) { (result) in
                
                let sectionItem = self.homeSectionItems[index]
                
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
                if let sc = self.contentsAdapter.sectionController(for: sectionItem) as? HomeHorizontalSectionController {
                    sc.adapter.performUpdates(animated: true, completion: nil)
                }
            }
        }
    }
}

extension HomeViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        switch listAdapter {
        case contentsAdapter:
            return homeSectionItems
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
