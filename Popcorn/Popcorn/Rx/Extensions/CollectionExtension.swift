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

extension Dictionary {
    func toJsonData() -> Data? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: self,
                                                      options: .prettyPrinted) {            
            return jsonData
        } else {
            return nil
        }
    }
    
    func toJsonString() -> String? {
        if let jsonData = toJsonData(), let jsonString = String(data: jsonData,
                                                                encoding: String.Encoding.ascii) {
            return jsonString
        } else {
            return nil
        }
    }
}
