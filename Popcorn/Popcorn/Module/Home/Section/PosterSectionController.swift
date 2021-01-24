//
//  PosterSectionController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import UIKit

class PosterSectionController: ListSectionController {
    var sectionItem: ContentsSectionItem?
    var direction: UICollectionView.ScrollDirection = .horizontal
    var uuid: String?
    
    override private init() {
        super.init()
        
        minimumLineSpacing = 12
    }
    
    convenience init(direction: UICollectionView.ScrollDirection) {
        self.init()
        self.direction = direction
    }
    
    override func numberOfItems() -> Int {
        return sectionItem?.items.count ?? 0
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, let sectionItem = sectionItem else { return .zero }
        switch direction {
        case .horizontal:
            switch sectionItem.sectionType {
            case .backdrop:
                return CGSize(width: context.containerSize.width - 60, height: context.containerSize.height)
            case .poster:
                let containerHeight: CGFloat = context.containerSize.height
                let titleTopMargin: CGFloat = 12
                let labelHeight: CGFloat = ceil(String.height(for: .systemFont(ofSize: 13, weight: .semibold))) * 2
                let posterHeight: CGFloat = containerHeight - titleTopMargin - labelHeight
                let posterRatio: CGFloat = 2 / 3
                let posterWidth: CGFloat = posterHeight * posterRatio
                return CGSize(width: posterWidth, height: containerHeight)
            }
        case .vertical:
            switch sectionItem.sectionType {
            case .backdrop:
                return CGSize(width: context.containerSize.width - 60, height: context.containerSize.height)
            case .poster:
                let numberOfItemInRow: CGFloat = 3
                let containerWidth = context.containerSize.width - context.containerInset.right - context.containerInset.left
                let width: CGFloat = (containerWidth - minimumLineSpacing * (numberOfItemInRow - 1)) / numberOfItemInRow
                let titleTopMargin: CGFloat = 12
                let labelHeight: CGFloat = ceil(String.height(for: .systemFont(ofSize: 13, weight: .semibold))) * 2
                let posterRatio: CGFloat = 2 / 3
                let heigth: CGFloat = (width / posterRatio) + titleTopMargin + labelHeight
                return CGSize(width: width, height: heigth)
            }
        default:
            return .zero
        }
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext, let sectionItem = sectionItem, let item = sectionItem.items[index] as? Movie else {
            return UICollectionViewCell()
        }
        
        switch sectionItem.sectionType {
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
                cell.posterHeroId = "\(viewController?.className ?? "")\(sectionItem.sectionType.title)\(item.id ?? 0)"
                cell.voteAverage = item.voteAverage
            }
            return cell
        }
    }
    
    override func didUpdate(to object: Any) {
        sectionItem = object as? ContentsSectionItem
    }
    
    override func didSelectItem(at index: Int) {
        guard let sectionItem = sectionItem, let item = sectionItem.items[index] as? Movie else {
            return
        }
        
        let vc = ContentsDetailViewController(id: item.id)
        vc.contents = item
        vc.posterHeroId = "\(viewController?.className ?? "")\(sectionItem.sectionType.title)\(item.id ?? 0)"
        
        viewController?.navigationController?.hero.navigationAnimationType = .fade
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
