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
        
        switch sectionItem.sectionType {
        case .popular:
            let backdropHeight = context.containerSize.width * 9 / 16 // 16:9 비율
            return CGSize(width: context.containerSize.width, height: backdropHeight)
        default:
            return CGSize(width: context.containerSize.width, height: 220)
        }
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext else { return UICollectionViewCell() }
        
        let cell: EmbeddedCollectionViewCell = context.dequeueReusableCell(for: self, at: index)
        let layout = PagingCollectionViewLayout()
        layout.scrollDirection = .horizontal
        cell.collectionView.collectionViewLayout = layout

        adapter.collectionView = cell.collectionView
        
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
        guard let context = collectionContext else { return .zero }

        return CGSize(width: context.containerSize.width, height: 72)
    }
    
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        guard let context = collectionContext else { return UICollectionReusableView() }
        
        let headerView: SectionHeaderView = context.dequeueReusableSupplementaryXibView(ofKind: UICollectionView.elementKindSectionHeader, for: self, at: index)
        headerView.expandable = true
        headerView.delegate = self
        headerView.title = sectionItem?.sectionType.title
        
        return headerView
    }
}

extension HomeHorizontalSectionController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard let sectionItem = sectionItem else {
            return []
        }
        
        switch sectionItem.sectionType {
        case .popular:
            return [ContentsSectionItem(.backdrop, items: sectionItem.items)]
        default:
            return [ContentsSectionItem(.poster, items: sectionItem.items)]
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return PosterSectionController(direction: .horizontal)
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension HomeHorizontalSectionController: SectionHeaderViewDelegate {
    func didTapExpandBtn() {
        guard let sectionItem = sectionItem else {
            return
        }
        
        let vc = ContentsListViewController(title: sectionItem.sectionType.title, sectionItem: ContentsSectionItem(.poster, items: sectionItem.items))
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
