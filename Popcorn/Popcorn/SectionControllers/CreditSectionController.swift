//
//  CreditSectionController.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/13.
//

import UIKit

class CreditSectionController: ListSectionController {
    var sectionItem: DetailSectionItem?
    var direction: UICollectionView.ScrollDirection = .horizontal

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
        guard let context = collectionContext else {
            return .zero
        }
        
        let containerHeight = context.containerSize.height - context.containerInset.top - context.containerInset.bottom
        let containerWidth = context.containerSize.width - context.containerInset.right - context.containerInset.left
        let imgRatio: CGFloat = 4 / 5
        let labelHeight: CGFloat = 55.5
        
        var size: CGSize = .zero

        switch direction {
        case .horizontal:
            size.width = (containerHeight - labelHeight) * imgRatio
            size.height = containerHeight
        case .vertical:
            let numberOfItemsInRow: CGFloat = 3
            size.width = (containerWidth - minimumLineSpacing * (numberOfItemsInRow - 1)) / numberOfItemsInRow
            size.height = (size.width / imgRatio) + labelHeight
        default:
            break
        }
        
        return size
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext, let sectionItem = sectionItem, let person = sectionItem.items[index] as? Person else {
            return UICollectionViewCell()
        }
        
        let cell: CreditCell = context.dequeueReusableXibCell(for: self, at: index)
        cell.profilePath = person.profilePath
        cell.name = person.name
        
        if let cast = person as? Cast {
            cell.desc = cast.character
        } else if let crew = person as? Crew {
            cell.desc = crew.job
        }
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        sectionItem = object as? DetailSectionItem
    }
}
