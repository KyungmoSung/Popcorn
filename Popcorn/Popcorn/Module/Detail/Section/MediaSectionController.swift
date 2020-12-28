//
//  MediaSectionController.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/13.
//

import Foundation

class MediaSectionController: ListSectionController {
    var media: Media?
    
    override init() {
        super.init()
        
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
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
        guard let context = collectionContext else {
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
        media = object as? Media
    }
}
