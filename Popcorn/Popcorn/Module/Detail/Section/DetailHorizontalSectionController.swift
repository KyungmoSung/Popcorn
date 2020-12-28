//
//  HorizontalSectionController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import UIKit

class DetailHorizontalSectionController: ListSectionController {

    private var sectionItem: DetailSectionItem?
    
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
        guard let context = collectionContext, let detailSection = sectionItem?.detailSection else {
            return .zero
        }
        
        return CGSize(width: context.containerSize.width, height: detailSection.height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext else { return UICollectionViewCell() }
        
        let cell: EmbeddedCollectionViewCell = context.dequeueReusableCell(for: self, at: index)
            if let detailSection = sectionItem?.detailSection, detailSection == .detail {
                let layout = PagingCollectionViewLayout()
                layout.scrollDirection = .horizontal
                layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
                cell.collectionView.collectionViewLayout = layout
                layout.invalidateLayout()
            } else {
                let layout = PagingCollectionViewLayout()
                layout.scrollDirection = .horizontal
                cell.collectionView.collectionViewLayout = layout
                layout.invalidateLayout()
            }
        adapter.collectionView = cell.collectionView
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        sectionItem = object as? DetailSectionItem
    }
}

extension DetailHorizontalSectionController: ListSupplementaryViewSource {
    func supportedElementKinds() -> [String] {
        return [UICollectionView.elementKindSectionHeader]
    }
    
    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        guard let context = collectionContext else { return .zero }

        return CGSize(width: context.containerSize.width, height: 70)
    }
    
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        guard let context = collectionContext else { return UICollectionReusableView() }
        
        let headerView: HomeHeaderView = context.dequeueReusableSupplementaryXibView(ofKind: UICollectionView.elementKindSectionHeader, for: self, at: index)
        headerView.title = sectionItem?.detailSection.title
        
        return headerView
    }
}

extension DetailHorizontalSectionController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return sectionItem?.items ?? []
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        guard let detailSection = sectionItem?.detailSection else {
            return ListSectionController()
        }
        
        switch detailSection {
        case .detail:
            return InfoCardSectionController()
        case .synopsis:
            return ListSectionController()
        case .image:
            return MediaSectionController()
        case .video:
            return MediaSectionController()
        case .credit:
            return CreditSectionController()
        case .recommendation:
            return PosterSectionController(type: .poster)
        case .similar:
            return PosterSectionController(type: .poster)
        case .review:
            return ReviewSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
