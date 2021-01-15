//
//  EmbeddedCollectionViewCell.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import Foundation

final class EmbeddedCollectionViewCell: UICollectionViewCell {
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: PagingCollectionViewLayout())
        view.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.decelerationRate = .fast
        view.clipsToBounds = false
        self.contentView.addSubview(view)
        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.frame
    }
}
