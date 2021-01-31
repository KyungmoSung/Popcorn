//
//  SynopsisSectionController.swift
//  Popcorn
//
//  Created by Kyungmo on 2021/01/10.
//

import Foundation
        
protocol SynopsisSectionControllerDelegate: class {
    func didTapSynopsisItem(at index: Int, isExpand: Bool)
}

class SynopsisSectionController: ListSectionController {
    var sectionItem: DetailSectionItem?
    var isExpand: Bool = false

    weak var delegate: SynopsisSectionControllerDelegate?
    
    override private init() {
        super.init()
    }
    
    convenience init(delegate: SynopsisSectionControllerDelegate?) {
        self.init()
        self.delegate = delegate
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

        return CGSize(width: containerWidth, height: containerHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext, let synopsis = sectionItem?.items[index] as? String else {
            return UICollectionViewCell()
        }
        
        let cell: SynopsisCell = context.dequeueReusableXibCell(for: self, at: index)
        cell.isTagline = isFirstSection && !isLastSection
        cell.isExpand = isExpand
        cell.synopsis = synopsis

        return cell
    }
    
    override func didUpdate(to object: Any) {
        sectionItem = object as? DetailSectionItem
    }
    
    override func didSelectItem(at index: Int) {
        guard let cell = collectionContext?.cellForItem(at: index, sectionController: self) as? SynopsisCell else {
            return
        }
        
        isExpand.toggle()
        
        cell.isExpand = isExpand
        delegate?.didTapSynopsisItem(at: index, isExpand: isExpand)
    }
}
