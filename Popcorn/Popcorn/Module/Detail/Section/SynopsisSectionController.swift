//
//  SynopsisSectionController.swift
//  Popcorn
//
//  Created by Kyungmo on 2021/01/10.
//

import Foundation
        
class SynopsisSectionController: ListSectionController {
    var synopsis: String?
    
    override init() {
        super.init()
        
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
            return .zero
        }
        
        return CGSize(width: context.containerSize.width - 60, height: context.containerSize.height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext else {
            return UICollectionViewCell()
        }
        
        let cell: SynopsisCell = context.dequeueReusableXibCell(for: self, at: index)
        cell.isTagline = isFirstSection && !isLastSection
        cell.synopsis = synopsis

        return cell
    }
    
    override func didUpdate(to object: Any) {
        synopsis = object as? String
    }
}
