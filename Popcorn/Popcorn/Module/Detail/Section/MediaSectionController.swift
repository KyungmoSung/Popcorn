//
//  MediaSectionController.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/13.
//

import Foundation

class MediaSectionController: ListSectionController {
    var mediaType: MediaType?
    var imageInfo: ImageInfo?
    var videoInfo: VideoInfo?
    
    init(mediaType: MediaType) {
        super.init()
        
        self.mediaType = mediaType
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, let mediaType = mediaType else {
            return .zero
        }
        
        let height = context.containerSize.height

        switch mediaType {
        case .backdrop, .poster:
            if let ratio = imageInfo?.aspectRatio {
                return CGSize(width: height * CGFloat(ratio), height: height)
            } else {
                return .zero
            }
        case .video:
            return CGSize(width: height / 9 * 16, height: height)
        }
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext, let mediaType = mediaType else {
            return UICollectionViewCell()
        }
        
        switch mediaType {
        case .backdrop, .poster:
            let cell: MediaImageCell = context.dequeueReusableXibCell(for: self, at: index)
            if let filePath = imageInfo?.filePath {
                cell.backdropImgPath = filePath
            }
            return cell
        case .video:
            let cell: MediaVideoCell = context.dequeueReusableXibCell(for: self, at: index)
            if let key = videoInfo?.key {
                cell.loadYouTube(key: key)
            }
            return cell
        }
    }
    
    override func didUpdate(to object: Any) {
        if let object = object as? ImageInfo {
            imageInfo = object
        } else if let object = object as? VideoInfo {
            videoInfo = object
        }
    }
}
