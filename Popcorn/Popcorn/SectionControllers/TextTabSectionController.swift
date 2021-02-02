//
//  TextTabSectionController.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/11.
//

import Foundation

protocol TextTabDelegate: class {
    func didSelectTab(index: Int, title: String)
}

class TextTabSectionController: ListSectionController {
    weak var delegate: TextTabDelegate?
    
    var title: String?
    
    override private init() {
        super.init()
        
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }
    
    convenience init(delegate: TextTabDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
            return .zero
        }
        
        return CGSize(width: 30, height: context.containerSize.height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext, let vc = viewController as? ContentsDetailViewController else {
            return UICollectionViewCell()
        }
        
        let cell: TextTabCell = context.dequeueReusableXibCell(for: self, at: index)
        cell.title = title
        cell.isSelected = (vc.selectedImageType.rawValue == section)
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        title = object as? String
    }
    
    override func didSelectItem(at index: Int) {
        guard let title = title else {
            return
        }
        
        delegate?.didSelectTab(index: section, title: title)
    }
}
