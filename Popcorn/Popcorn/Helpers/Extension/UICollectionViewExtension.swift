//
//  UICollectionViewExtension.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/12/15.
//

import Foundation

extension UICollectionView {
    func centerContentHorizontalyByInsetIfNeeded(minimumInset: UIEdgeInsets) {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout, layout.scrollDirection == .horizontal else {
            assertionFailure("\(#function): layout.scrollDirection != .horizontal")
            return
        }
        
        if layout.collectionViewContentSize.width > frame.size.width {
            contentInset = minimumInset
        } else {
            let left = (frame.size.width - layout.collectionViewContentSize.width) / 2
            contentInset = UIEdgeInsets(top: minimumInset.top, left: left, bottom: minimumInset.bottom, right: 0)
        }
    }
}
