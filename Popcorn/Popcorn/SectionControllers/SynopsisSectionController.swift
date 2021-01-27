//
//  SynopsisSectionController.swift
//  Popcorn
//
//  Created by Kyungmo on 2021/01/10.
//

import Foundation
        
class SynopsisSectionController: ListSectionController {
    var sectionItem: DetailSectionItem?

    override init() {
        super.init()
    }

    override func numberOfItems() -> Int {
        return sectionItem?.items.count ?? 0
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
            return .zero
        }
        
        return CGSize(width: context.containerSize.width - 60, height: context.containerSize.height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext, let synopsis = sectionItem?.items[index] as? String else {
            return UICollectionViewCell()
        }
        
        let cell: SynopsisCell = context.dequeueReusableXibCell(for: self, at: index)
        cell.isTagline = isFirstSection && !isLastSection
        cell.synopsis = synopsis

        return cell
    }
    
    override func didUpdate(to object: Any) {
        sectionItem = object as? DetailSectionItem
    }
}
