//
//  EmbeddedCollectionViewCell.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import Foundation

final class EmbeddedCollectionViewCell: UICollectionViewCell {

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset.left = 20
//        layout.estimatedItemSize = CGSize(width: 100, height: 40)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = true
        view.decelerationRate = .fast
        self.contentView.addSubview(view)
        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.frame
    }
}
