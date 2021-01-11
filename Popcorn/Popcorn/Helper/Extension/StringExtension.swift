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
    
    /// 뷰 넓이에 맞춘 높이 계산
    func height(for font: UIFont, lineSpacing: CGFloat = 6, numberOfLines: Int = 0, width: CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))

        let attributedString = NSMutableAttributedString(string: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let attributes = [NSAttributedString.Key.font: font,
                          NSAttributedString.Key.paragraphStyle: paragraphStyle]
        
        attributedString.addAttributes(attributes, range: NSMakeRange(0, attributedString.length))

        label.attributedText = attributedString
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = numberOfLines
        label.sizeToFit()
        
        return label.frame.height
    }
    
    func attributedString(font: UIFont, lineSpacing: CGFloat = 6) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let attributes = [NSAttributedString.Key.font: font,
                          NSAttributedString.Key.paragraphStyle: paragraphStyle]
        
        attributedString.addAttributes(attributes, range: NSMakeRange(0, attributedString.length))
        
        return attributedString
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
    }
    
    static func NanumSquare(size: CGFloat, family: Family.NanumSquare = .Regular) -> UIFont {
        return UIFont(name: "NanumSquare\(family.rawValue)", size: size)!
    }
}
