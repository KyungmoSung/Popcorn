//
//  File.swift
//  Popcorn
//
//  Created by Kyungmo on 2021/02/07.
//

import Foundation

extension Date {
    func toString(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
}
