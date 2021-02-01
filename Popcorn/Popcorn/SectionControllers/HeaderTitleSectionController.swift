//
//  TextTagSectionController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/12/15.
//

import Foundation

protocol HeaderTitleSectionDelegate: class {
    func didSelectHeaderTitle(section: Int)
}

class HeaderTitleSectionController: ListSectionController {
    var title: String?
    weak var delegate: HeaderTitleSectionDelegate?
    
    override private init() {
        super.init()
        
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6)
    }
    
    convenience init(delegate: HeaderTitleSectionDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else { return .zero }
        
        return context.containerSize
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext, let title = title, let vc = viewController as? ContentsDetailViewController else {
            return UICollectionViewCell()
        }
        
        let cell: HeaderTitleCell = context.dequeueReusableXibCell(for: self, at: index)
        cell.title = title
        cell.isSelected = (vc.selectedImageTitleIndex == section)
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        title = object as? String
    }
    
    override func didSelectItem(at index: Int) {
        delegate?.didSelectHeaderTitle(section: section)
    }
}
