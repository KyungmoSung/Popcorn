//
//  PosterSectionController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import UIKit

class PosterSectionController: ListSectionController {

    var homeSection: Section.Home?
    var contents: Movie?
    var uuid = UUID().uuidString
    
    override private init() {
        super.init()
        
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
    }
    
    convenience init(homeSection: Section.Home) {
        self.init()
        self.homeSection = homeSection
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, let homeSection = homeSection else { return .zero }
        
        switch homeSection {
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
        guard let context = collectionContext, let homeSection = homeSection else { return UICollectionViewCell() }

        switch homeSection {
        case .popular:
            let cell: HomeBackdropCell = context.dequeueReusableXibCell(for: self, at: index)
            
            cell.backdropImgPath = contents?.backdropPath
            cell.voteAverage = contents?.voteAverage
            cell.title = contents?.title
            cell.originalTitle = contents?.originalTitle
            cell.releaseDate = contents?.releaseDate.dateValue()
            return cell
        default:
            let cell: HomePosterCell = context.dequeueReusableXibCell(for: self, at: index)
            
            cell.title = contents?.title
            cell.posterImgPath = contents?.posterPath
            cell.posterHeroId = uuid
            cell.voteAverage = contents?.voteAverage
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
        vc.contents = contents
        vc.posterHeroId = uuid
        
        viewController?.navigationController?.hero.navigationAnimationType = .fade
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
