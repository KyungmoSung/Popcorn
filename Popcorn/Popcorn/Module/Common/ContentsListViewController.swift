//
//  ContentsListViewController.swift
//  Popcorn
//
//  Created by Kyungmo on 2021/01/24.
//

import UIKit

class ContentsListViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    var sectionItem: ContentsSectionItem!
    
    convenience init(title: String, sectionItem: ContentsSectionItem) {
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
}

extension ContentsListViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [sectionItem]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return PosterSectionController(direction: .vertical)
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

