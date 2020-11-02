//
//  EmbeddedSectionController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import UIKit

class EmbeddedSectionController: ListSectionController {

    var contents: Movie?
    
    override init() {
        super.init()
        
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
            return .zero
        }
        
        let height = context.containerSize.height
        return CGSize(width: height / 2, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell: HomeContentsCell = collectionContext?.dequeueReusableXibCell(for: self, at: index) else {
            return UICollectionViewCell()
        }
        
        cell.title = contents?.title
        return cell
    }
    
    override func didUpdate(to object: Any) {
        contents = object as? Movie
    }
}
