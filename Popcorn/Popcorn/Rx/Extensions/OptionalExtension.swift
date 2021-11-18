//
//  ArrayExtension.swift
//  Popcorn
//
//  Created by Kyungmo on 2021/02/09.
//

import Foundation

extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        if let self = self {
            return self.isEmpty
        } else {
            return true
        }
    }
    
    var count: Int {
        if let self = self {
            return self.count
        } else {
            return 0
        }
    }
}

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        if let self = self {
            return self.isEmpty
        } else {
            return true
        }
    }
}
