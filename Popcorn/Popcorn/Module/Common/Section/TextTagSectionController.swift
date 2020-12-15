//
//  TextTagSectionController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/12/15.
//

import Foundation

protocol TextTagDelegate: class {
    func didSelectTag(index: Int)
}

class TextTagSectionController: ListSectionController {
    var title: String?
    weak var delegate: TextTagDelegate?
    
    override init() {
        super.init()
        
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else { return .zero }
        
        return CGSize(width: 30, height: context.containerSize.height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext, let title = title else { return UICollectionViewCell() }
        
        let cell: TextTagCell = context.dequeueReusableXibCell(for: self, at: index)
        cell.title = title
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        title = object as? String
    }
    
    override func didSelectItem(at index: Int) {
        delegate?.didSelectTag(index: section)
    }
}
