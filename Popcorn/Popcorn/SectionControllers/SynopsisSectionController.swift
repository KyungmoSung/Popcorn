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
        guard let context = collectionContext, let sectionItem = sectionItem, let originText = sectionItem.items[index] as? String else {
            return .zero
        }
        
        let containerWidth = context.containerSize.width - context.containerInset.right - context.containerInset.left
        
        let isTagline = sectionItem.items.count > 1 && index == 0
        let font = UIFont.NanumSquare(size: 14, family: isTagline ? .ExtraBold : .Regular)
        let numberOfLines = isTagline ? 0 : (isExpand ? 0 : 5)

        let text = isTagline ? originText : (isExpand ? originText.replacingOccurrences(of: ". ", with: ".\n\n") : originText)

        let height = text.height(for: font, numberOfLines: numberOfLines, width: containerWidth)

        return CGSize(width: containerWidth, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext, let sectionItem = sectionItem, let synopsis = sectionItem.items[index] as? String else {
            return UICollectionViewCell()
        }
        
        let cell: SynopsisCell = context.dequeueReusableXibCell(for: self, at: index)
        cell.isTagline = sectionItem.items.count > 1 && index == 0
        cell.isExpand = isExpand
        cell.synopsis = synopsis

        return cell
    }
    
    override func didUpdate(to object: Any) {
        sectionItem = object as? DetailSectionItem
    }
    
    override func didSelectItem(at index: Int) {
        guard let cells = collectionContext?.visibleCells(for: self) else {
            return
        }
        
        isExpand.toggle()
        
        cells.forEach {
            if let cell = $0 as? SynopsisCell {
                cell.isExpand = isExpand
            }
        }
        
        delegate?.didTapSynopsisItem(at: index, isExpand: isExpand)
    }
}
