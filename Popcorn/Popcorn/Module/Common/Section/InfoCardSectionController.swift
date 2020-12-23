//
//  InfoCardSectionController.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/23.
//

import Foundation


class InfoItem: NSObject, ListDiffable {
    var title: String
    var desc: String
    
    init(title: String, desc: String) {
        self.title = title
        self.desc = desc
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}

class InfoCardSectionController: ListSectionController {
    var info: InfoItem?
    
    override init() {
        super.init()
        
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else { return .zero }
        
        return CGSize(width: 30, height: context.containerSize.height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext, let info = info else { return UICollectionViewCell() }
        
        let cell: InfoCardCell = context.dequeueReusableXibCell(for: self, at: index)
        cell.title = info.title
        cell.desc = info.desc
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        info = object as? InfoItem
    }
}
