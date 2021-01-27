//
//  ReviewSectionController.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/27.
//

import Foundation

class ReviewSectionController: ListSectionController {
    var sectionItem: DetailSectionItem?
    var direction: UICollectionView.ScrollDirection = .horizontal
    
    override private init() {
        super.init()
        
        minimumLineSpacing = 12
    }
    
    convenience init(direction: UICollectionView.ScrollDirection) {
        self.init()
        self.direction = direction
    }
    
    override func numberOfItems() -> Int {
        return sectionItem?.items.count ?? 0
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, let review = sectionItem?.items[index] as? Review else {
            return .zero
        }
        
        let containerHeight = context.containerSize.height - context.containerInset.top - context.containerInset.bottom
        let containerWidth = context.containerSize.width - context.containerInset.right - context.containerInset.left
        
        var size: CGSize = .zero
        
        switch direction {
        case .horizontal:
            size.width = containerWidth
            size.height = containerHeight
        case .vertical:
            let font = UIFont.NanumSquare(size: 14, family: .Regular)
            let labelHeight = review.content.height(for: font, lineSpacing: 6, numberOfLines: 0, width: containerWidth - 40)
            size.width = containerWidth
            size.height = 110 + labelHeight
        default:
            break
        }
        
        return size
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
