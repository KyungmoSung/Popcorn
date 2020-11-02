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
        guard let context = collectionContext else { return .zero }
        
        let containerHeight: CGFloat = context.containerSize.height
        let titleTopMargin: CGFloat = 12
        let posterHeight: CGFloat = containerHeight - titleTopMargin - String.height(for: .systemFont(ofSize: 16))
        let posterRatio: CGFloat = 2 / 3
        let posterWidth: CGFloat = posterHeight * posterRatio
        return CGSize(width: posterWidth, height: containerHeight)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell: HomeContentsCell = collectionContext?.dequeueReusableXibCell(for: self, at: index) else { return UICollectionViewCell() }
        
        cell.title = contents?.title
        cell.posterImgPath = contents?.posterPath
        return cell
    }
    
    override func didUpdate(to object: Any) {
        contents = object as? Movie
    }
}
