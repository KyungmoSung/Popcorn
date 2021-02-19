//
//  DetailInfo.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/01/25.
//

import Foundation

class DetailInfo: NSObject, ListDiffable {
    var title: String
    var desc: String
    
    init(title: String, desc: String) {
        self.title = title
        self.desc = desc
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return title as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let object = object as? DetailInfo {
            return desc == object.desc
        }
        
        return false
    }
}
