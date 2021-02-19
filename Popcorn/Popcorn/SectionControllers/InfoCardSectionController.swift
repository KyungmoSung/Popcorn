//
//  InfoCardSectionController.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/23.
//

import Foundation

class InfoCardSectionController: ListSectionController {
    var sectionItem: SectionItem?
    
    override init() {
        super.init()
        
        minimumLineSpacing = 12
    }
    
    override func numberOfItems() -> Int {
        return sectionItem?.items.count ?? 0
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else { return .zero }
        
        return CGSize(width: 30, height: context.containerSize.height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext, let info = sectionItem?.items[index] as? DetailInfo else {
            return UICollectionViewCell()
        }

        let cell: InfoCardCell = context.dequeueReusableXibCell(for: self, at: index)
        cell.title = info.title
        cell.desc = info.desc
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        sectionItem = object as? SectionItem
    }
}
