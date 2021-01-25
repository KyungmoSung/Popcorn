//
//  MediaSectionController.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/13.
//

import Foundation

class MediaSectionController: ListSectionController {
    var sectionItem: DetailSectionItem?
    
    override init() {
        super.init()
        
        minimumLineSpacing = 12
        minimumInteritemSpacing = 12
    }
    
    override func numberOfItems() -> Int {
        return sectionItem?.items.count ?? 0
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, let media = sectionItem?.items[index] as? Media else {
            return .zero
        }
        
        let height = context.containerSize.height

        switch media {
        case let imageInfo as ImageInfo:
            return CGSize(width: height * CGFloat(imageInfo.aspectRatio), height: height)
        case is VideoInfo:
            return CGSize(width: height / 9 * 16, height: height)
        default:
            return .zero
        }
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext, let media = sectionItem?.items[index] as? Media else {
            return UICollectionViewCell()
        }
        
        switch media {
        case let imageInfo as ImageInfo:
            let cell: MediaImageCell = context.dequeueReusableXibCell(for: self, at: index)
            cell.backdropImgPath = imageInfo.filePath
            return cell
        case let videoInfo as VideoInfo:
            let cell: MediaVideoCell = context.dequeueReusableXibCell(for: self, at: index)
            cell.loadYouTube(key: videoInfo.key)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    override func didUpdate(to object: Any) {
        sectionItem = object as? DetailSectionItem
    }
}
