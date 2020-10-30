//
//  EmbeddedSectionController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import UIKit

class EmbeddedSectionController: ListSectionController {

    var contents: Movie?
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: 100, height: collectionContext!.containerSize.height)
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
