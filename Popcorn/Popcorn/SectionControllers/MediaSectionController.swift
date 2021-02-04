//
//  MediaSectionController.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/13.
//

import Foundation

class MediaSectionController: ListSectionController {
    var sectionItem: SectionItem?
    var direction: UICollectionView.ScrollDirection = .horizontal
    
    override private init() {
        super.init()
        
        minimumLineSpacing = 12
        minimumInteritemSpacing = 12
    }
    
    convenience init(direction: UICollectionView.ScrollDirection) {
        self.init()
        self.direction = direction
    }
    
    override func numberOfItems() -> Int {
        return sectionItem?.items.count ?? 0
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, let media = sectionItem?.items[index] as? Media else {
            return .zero
        }
        
        let containerHeight = context.containerSize.height - context.containerInset.top - context.containerInset.bottom
        let containerWidth = context.containerSize.width - context.containerInset.right - context.containerInset.left
        let videoRatio: CGFloat = 16 / 9
        
        var size: CGSize = .zero
        
        switch direction {
        case .horizontal:
            switch media {
            case let imageInfo as ImageInfo:
                size.width = containerHeight * CGFloat(imageInfo.aspectRatio)
                size.height = containerHeight
            case is VideoInfo:
                size.width = containerHeight * videoRatio
                size.height = containerHeight
            default:
                break
            }
        case .vertical:
            switch media {
            case let imageInfo as ImageInfo:
                switch imageInfo.type {
                case .backdrop:
                    size.width = containerWidth
                    size.height = containerWidth / CGFloat(imageInfo.aspectRatio)
                case .poster:
                    let numberOfItemsInRow: CGFloat = 2
                    size.width = (containerWidth - minimumLineSpacing * (numberOfItemsInRow - 1)) / numberOfItemsInRow
                    size.height = size.width / CGFloat(imageInfo.aspectRatio)
                default:
                    break
                }
            case is VideoInfo:
                size.width = containerWidth
                size.height = containerWidth / videoRatio
            default:
                break
            }
        default:
            break
        }
        
        return size
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
        sectionItem = object as? SectionItem
    }
}
