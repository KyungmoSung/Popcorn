//
//  CollectionExtension.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/06.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
