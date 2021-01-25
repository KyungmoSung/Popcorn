//
//  ReviewSectionController.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/27.
//

import Foundation

class ReviewSectionController: ListSectionController {
    var sectionItem: DetailSectionItem?
    
    override init() {
        super.init()
        
        minimumLineSpacing = 12
    }
    
    override func numberOfItems() -> Int {
        return sectionItem?.items.count ?? 0
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
            return .zero
        }
        
        let insets = context.containerInset.left * 2
        return CGSize(width: context.containerSize.width - insets, height: context.containerSize.height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext, let review = sectionItem?.items[index] as? Review else {
            return UICollectionViewCell()
        }
        
        let cell: ReviewCell = context.dequeueReusableXibCell(for: self, at: index)
        cell.avatarPath = review.authorDetails.avatarPath
        cell.name = review.author ?? review.authorDetails.username
        cell.contents = review.content
        cell.rate = review.authorDetails.rating
        
        if let dateStr = review.updatedAt ?? review.createdAt, let date = dateStr.dateValue(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd"
            cell.date = dateFormatter.string(from: date)
        }
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        sectionItem = object as? DetailSectionItem
    }
}
