//
//  StringExtension.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/11/02.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func height(for font: UIFont) -> CGFloat {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font : font]).height
    }
    
    static func height(for font: UIFont) -> CGFloat {
        return "".height(for: font)
    }
}
