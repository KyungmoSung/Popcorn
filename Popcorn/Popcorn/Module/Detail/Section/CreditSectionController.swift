//
//  CreditSectionController.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/13.
//

import UIKit

class CreditSectionController: ListSectionController {
    var person: Person?
    
    override init() {
        super.init()
        
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
            return .zero
        }
        
        let height = context.containerSize.height
        return CGSize(width: height * 0.5, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext else {
            return UICollectionViewCell()
        }
        
        let cell: CreditCell = context.dequeueReusableXibCell(for: self, at: index)
        cell.profilePath = person?.profilePath
        cell.name = person?.name
        
        if let cast = person as? Cast {
            cell.desc = cast.character
        } else if let crew = person as? Crew {
            cell.desc = crew.job
        }
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        person = object as? Person
    }
}
