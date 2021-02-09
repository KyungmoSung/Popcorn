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
    var sectionItem: SectionItem?
    var isExpandable: Bool = false
    var isExpanded: Bool = false

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

        let containerWidth: CGFloat = context.containerSize.width - context.containerInset.right - context.containerInset.left
        var height: CGFloat = 0
        
        let isTagline = sectionItem.items.count > 1 && index == 0
        let font = UIFont.NanumSquare(size: 14, family: isTagline ? .ExtraBold : .Regular)
        let maxNumberOfLines = originText.maxNumberOfLines(for: font, width: containerWidth)
        
        if isTagline {
            height = originText.height(for: font, numberOfLines: 0, width: containerWidth)
        } else {
            if maxNumberOfLines > 5 {
                isExpandable = true
                
                let numberOfLines = isExpanded ? 0 : 5
                let text = isExpanded ? originText.replacingOccurrences(of: ". ", with: ".\n\n") : originText
                
                height = text.height(for: font, numberOfLines: numberOfLines, width: containerWidth)
            } else {
                isExpandable = false
                
                height = originText.height(for: font, numberOfLines: maxNumberOfLines, width: containerWidth)
            }
        }
        
        return CGSize(width: containerWidth, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext, let sectionItem = sectionItem, let synopsis = sectionItem.items[index] as? String else {
            return UICollectionViewCell()
        }
        
        let cell: SynopsisCell = context.dequeueReusableXibCell(for: self, at: index)
        cell.isTagline = sectionItem.items.count > 1 && index == 0
        cell.isExpandable = isExpandable
        cell.isExpand = isExpanded
        cell.synopsis = synopsis

        return cell
    }
    
    override func didUpdate(to object: Any) {
        sectionItem = object as? SectionItem
    }
    
    override func didSelectItem(at index: Int) {
        guard isExpandable, let cells = collectionContext?.visibleCells(for: self) else {
            return
        }
        
        isExpanded.toggle()
        
        cells.forEach {
            if let cell = $0 as? SynopsisCell {
                cell.isExpand = isExpanded
            }
        }
        
        delegate?.didTapSynopsisItem(at: index, isExpand: isExpanded)
    }
}
