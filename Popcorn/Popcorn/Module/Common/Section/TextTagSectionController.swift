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
    var tag: Tag?
    weak var delegate: TextTagDelegate?
    
    override private init() {
        super.init()
        
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6)
    }
    
    convenience init(delegate: TextTagDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else { return .zero }
        
        return CGSize(width: 30, height: context.containerSize.height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext, let tag = tag else { return UICollectionViewCell() }
        
        let cell: TextTagCell = context.dequeueReusableXibCell(for: self, at: index)
        if tag.isLoading {
            cell.showAnimatedGradientSkeleton(transition: .crossDissolve(0.3))
        } else {
            cell.hideSkeleton(transition: .crossDissolve(0.3))
            cell.title = tag.name
        }
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        tag = object as? Tag
    }
    
    override func didSelectItem(at index: Int) {
        delegate?.didSelectTag(index: section)
    }
}
