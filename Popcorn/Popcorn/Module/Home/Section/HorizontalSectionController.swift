//
//  HorizontalSectionController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import UIKit

class HorizontalSectionController: ListSectionController {

    private var contentsCollection: ContentsCollection?
    
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
        guard let context = collectionContext, let homeSection = contentsCollection?.homeSection else { return .zero }
        
        if homeSection == .popular {
            let backdropHeight = context.containerSize.width * 9 / 16 // 16:9 비율
            return CGSize(width: context.containerSize.width, height: backdropHeight)
        } else {
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
        contentsCollection = object as? ContentsCollection
    }
}

extension HorizontalSectionController: ListSupplementaryViewSource {
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
        headerView.title = contentsCollection?.homeSection.title
        
        return headerView
    }
}

extension HorizontalSectionController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return contentsCollection?.contents ?? []
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        guard let homeSection = contentsCollection?.homeSection else {
            return ListSectionController()
        }
        
        switch homeSection {
        case .popular:
            return PosterSectionController(type: .backdrop)
        default:
            return PosterSectionController(type: .poster)
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
