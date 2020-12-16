//
//  EmbeddedSectionController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import UIKit

class EmbeddedSectionController: ListSectionController {

    var category: ContentsCategory?
    var contents: Movie?
    
    override private init() {
        super.init()
        
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
    }
    
    convenience init(category: ContentsCategory) {
        self.init()
        self.category = category
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, let category = category else { return .zero }
        
        switch category {
        case .popular:
            return CGSize(width: context.containerSize.width - 60, height: context.containerSize.height)
        default:
            let containerHeight: CGFloat = context.containerSize.height
            let titleTopMargin: CGFloat = 12
            let labelHeight: CGFloat = ceil(String.height(for: .systemFont(ofSize: 13, weight: .semibold))) * 2
            let posterHeight: CGFloat = containerHeight - titleTopMargin - labelHeight
            let posterRatio: CGFloat = 2 / 3
            let posterWidth: CGFloat = posterHeight * posterRatio
            return CGSize(width: posterWidth, height: containerHeight)
        }
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext, let category = category else { return UICollectionViewCell() }

        switch category {
        case .popular:
            let cell: HomeBackdropCell = context.dequeueReusableXibCell(for: self, at: index)
            
            cell.backdropImgPath = contents?.backdropPath
            cell.title = contents?.title
            cell.index = section
            return cell
        default:
            let cell: HomePosterCell = context.dequeueReusableXibCell(for: self, at: index)
            
            cell.title = contents?.title
            cell.posterImgPath = contents?.posterPath
            return cell
        }
        
    }
    
    override func didUpdate(to object: Any) {
        contents = object as? Movie
    }
    
    override func didSelectItem(at index: Int) {
        guard let contents = contents else {
            return
        }
        let vc = ContentsDetailViewController(id: contents.id)
        vc.modalPresentationStyle = .fullScreen
        vc.contents = contents
        viewController?.present(vc, animated: true, completion: nil)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
