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

extension UIFont {
    struct Family {
        enum NanumSquare: String {
            case Light = "L"
            case Regular = "R"
            case Bold = "B"
            case ExtraBold = "EB"
        }
//        enum NanumBarunGothic: String {
//            case UltraLight, Light, Regular, Bold
//        }
    }
    
    static func NanumSquare(size: CGFloat, family: Family.NanumSquare = .Regular) -> UIFont {
        return UIFont(name: "NanumSquare\(family.rawValue)", size: size)!
    }
    
//    static func NanumBarunGothic(size: CGFloat, family: Family.NanumBarunGothic = .Regular) -> UIFont {
//        return UIFont(name: "NanumBarunGothic\(family)", size: size)!
//    }
}
