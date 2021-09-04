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
    
    func register<T: UICollectionViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: className)
    }
    
    func register<T: UICollectionViewCell>(cellTypes: [T.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { register(cellType: $0, bundle: bundle) }
    }
    
    func register<T: UICollectionReusableView>(reusableViewType: T.Type,
                                               ofKind kind: String = UICollectionView.elementKindSectionHeader,
                                               bundle: Bundle? = nil) {
        let className = reusableViewType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: className)
    }
    
    func register<T: UICollectionReusableView>(reusableViewTypes: [T.Type],
                                               ofKind kind: String = UICollectionView.elementKindSectionHeader,
                                               bundle: Bundle? = nil) {
        reusableViewTypes.forEach { register(reusableViewType: $0, ofKind: kind, bundle: bundle) }
    }
    
    @available(*, deprecated)
    func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type,
                                                      for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: type.className, for: indexPath) as? T
    }
    
    @available(*, deprecated)
    func dequeueReusableView<T: UICollectionReusableView>(with type: T.Type,
                                                          for indexPath: IndexPath,
                                                          ofKind kind: String = UICollectionView.elementKindSectionHeader) -> T? {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type.className, for: indexPath) as? T
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type,
                                                      for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: type.className, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(type.className)")
        }
        
        return cell
    }
    
    func dequeueReusableView<T: UICollectionReusableView>(with type: T.Type,
                                                          for indexPath: IndexPath,
                                                          ofKind kind: String = UICollectionView.elementKindSectionHeader) -> T {
        guard let cell =  dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type.className, for: indexPath) as? T else {
            fatalError("Could not dequeue reusableView with identifier: \(type.className)")
        }
        
        return cell
    }
}
