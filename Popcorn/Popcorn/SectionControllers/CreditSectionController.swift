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
        
        switch direction {
        case .horizontal:
            return CGSize(width: containerHeight * 0.5, height: containerHeight)
        case .vertical:
            let numberOfItemsInRow: CGFloat = 3
            let width: CGFloat = (containerWidth - minimumLineSpacing * (numberOfItemsInRow - 1)) / numberOfItemsInRow

//            let height = context.containerSize.height
            return CGSize(width: width, height: width * 2)
        default:
            return .zero
        }
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