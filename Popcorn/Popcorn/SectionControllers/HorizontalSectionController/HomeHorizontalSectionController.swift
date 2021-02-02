//
//  HomeHorizontalSectionController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import UIKit

class HomeHorizontalSectionController: ListSectionController {

    private var sectionItem: HomeSectionItem?
    
    lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self.viewController)
        adapter.dataSource = self
        return adapter
    }()
    
    override init() {
        super.init()
        supplementaryViewSource = self
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, let sectionItem = sectionItem else {
            return .zero
        }
        
        var size = context.containerSize
        
        switch sectionItem.sectionType {
        case .popular:
            size.height = context.containerSize.width * 9 / 16 // 16:9 비율
        default:
            size.height = 220
        }
        
        return size
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext, let sectionItem = sectionItem else {
            return UICollectionViewCell()
        }
        
        let cell: EmbeddedCollectionViewCell = context.dequeueReusableCell(for: self, at: index)
        adapter.collectionView = cell.collectionView
        
        if let layout = cell.collectionView.collectionViewLayout as? PagingCollectionViewLayout {
            layout.scrollDirection = .horizontal
            cell.collectionView.isScrollEnabled = true
        }
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        sectionItem = object as? HomeSectionItem
    }
}

extension HomeHorizontalSectionController: ListSupplementaryViewSource {
    func supportedElementKinds() -> [String] {
        return [UICollectionView.elementKindSectionHeader]
    }
    
    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        guard let context = collectionContext else {
            return .zero
        }
        
        return CGSize(width: context.containerSize.width, height: 85)
    }
    
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        guard let context = collectionContext else { return UICollectionReusableView() }
        
        let headerView: SectionHeaderView = context.dequeueReusableSupplementaryXibView(ofKind: UICollectionView.elementKindSectionHeader, for: self, at: index)
        headerView.expandable = true
        headerView.delegate = self
        headerView.title = sectionItem?.sectionType.title
        headerView.tabCollectionView.isHidden = true
        
        return headerView
    }
}

extension HomeHorizontalSectionController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard let sectionItem = sectionItem else {
            return []
        }
        
        return [sectionItem]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        guard let sectionItem = sectionItem else {
            return ListSectionController()
        }

        switch sectionItem.sectionType {
        case .popular:
            return PosterSectionController(type: .backdrop, direction: .horizontal)
        default:
            return PosterSectionController(type: .poster, direction: .horizontal)
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension HomeHorizontalSectionController: SectionHeaderViewDelegate {
    func didTapExpandBtn(index: Int) {
        guard let sectionItem = sectionItem else {
            return
        }
        
        let vc = ContentsListViewController(title: sectionItem.sectionType.title, sectionItem: sectionItem)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
