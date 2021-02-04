//
//  ContentsListViewController.swift
//  Popcorn
//
//  Created by Kyungmo on 2021/01/24.
//

import UIKit

class ContentsListViewController: BaseViewController, ListAdapterDataSource {
    @IBOutlet weak var collectionView: UICollectionView!

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    var sectionItem: SectionItem!
    
    convenience init(title: String, sectionItem: SectionItem) {
        self.init()

        self.title = title
        self.sectionItem = sectionItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigation(title: title)
        
        collectionView.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [sectionItem]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        guard let object = object as? SectionItem else {
            return ListSectionController()
        }
        
        switch object.items.first {
        case is Movie, is TVShow:
            return PosterSectionController(type: .poster, direction: .vertical)
        case is Person:
            return CreditSectionController(direction: .vertical)
        case is Media:
            return MediaSectionController(direction: .vertical)
        case is Review:
            return ReviewSectionController(direction: .vertical)
        default:
            return ListSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

