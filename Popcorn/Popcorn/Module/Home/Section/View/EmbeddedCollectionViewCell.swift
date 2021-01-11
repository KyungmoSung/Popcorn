//
//  EmbeddedCollectionViewCell.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import Foundation

final class EmbeddedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
}
