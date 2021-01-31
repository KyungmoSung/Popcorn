//
//  PosterSectionController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import UIKit

class PosterSectionController: ListSectionController {
    var sectionItem: ListDiffableItems?
    var type: ImageType = .poster
    var direction: UICollectionView.ScrollDirection = .horizontal
    var uuid: String = UUID().uuidString
    
    override private init() {
        super.init()
        
        minimumLineSpacing = 12
    }
    
    convenience init(type: ImageType, direction: UICollectionView.ScrollDirection) {
        self.init()
        
        self.type = type
        self.direction = direction
    }
    
    override func numberOfItems() -> Int {
        return sectionItem?.items.count ?? 0
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
            return .zero
        }
        
        let containerHeight = context.containerSize.height - context.containerInset.top - context.containerInset.bottom
        let containerWidth = context.containerSize.width - context.containerInset.right - context.containerInset.left
        let posterRatio: CGFloat = 2 / 3
        let titleTopMargin: CGFloat = 12
        let labelHeight: CGFloat = 29

        var size: CGSize = .zero
        
        switch direction {
        case .horizontal:
            switch type {
            case .backdrop:
                size.width = context.containerSize.width - 60
                size.height = containerHeight
            case .poster:
                size.width = (containerHeight - titleTopMargin - labelHeight) * posterRatio
                size.height = containerHeight
            }
        case .vertical:
            let numberOfItemInRow: CGFloat = 3
            size.width = (containerWidth - minimumLineSpacing * (numberOfItemInRow - 1)) / numberOfItemInRow
            size.height = (size.width / posterRatio) + titleTopMargin + labelHeight
        default:
            break
        }
        
        return size
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext, let sectionItem = sectionItem, let item = sectionItem.items[index] as? Movie else {
            return UICollectionViewCell()
        }
        
        switch type {
        case .backdrop:
            let cell: HomeBackdropCell = context.dequeueReusableXibCell(for: self, at: index)
            if item.isLoading {
                cell.showAnimatedGradientSkeleton(transition: .crossDissolve(0.3))
            } else {
                cell.hideSkeleton(transition: .crossDissolve(0.3))
                cell.backdropImgPath = item.backdropPath
                cell.voteAverage = item.voteAverage
                cell.title = item.title
                cell.originalTitle = item.originalTitle
                cell.releaseDate = item.releaseDate.dateValue()
            }
            return cell
        default:
            let cell: HomePosterCell = context.dequeueReusableXibCell(for: self, at: index)
            if item.isLoading {
                cell.showAnimatedGradientSkeleton(transition: .crossDissolve(0.3))
            } else {
                cell.hideSkeleton(transition: .crossDissolve(0.3))
                cell.title = item.title
                cell.posterImgPath = item.posterPath
                cell.posterHeroId = "\(viewController?.className ?? "")\(uuid)\(item.id ?? 0)"
                cell.voteAverage = item.voteAverage
            }
            return cell
        }
    }
    
    override func didUpdate(to object: Any) {
        sectionItem = object as? ListDiffableItems
    }
    
    override func didSelectItem(at index: Int) {
        guard let sectionItem = sectionItem, let item = sectionItem.items[index] as? Movie else {
            return
        }
        
        let vc = ContentsDetailViewController(id: item.id)
        vc.contents = item
        vc.posterHeroId = "\(viewController?.className ?? "")\(uuid)\(item.id ?? 0)"
        
        viewController?.navigationController?.hero.navigationAnimationType = .fade
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
