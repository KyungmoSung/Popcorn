//
//  CustomView.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/11/02.
//

import UIKit

@IBDesignable
class CustomView: UIView {
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        updateCorners()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateCorners()
    }
    
    func updateCorners() {
        var corners = CACornerMask()

        if topLeft {
            corners.formUnion(.layerMinXMinYCorner)
        }
        if topRight {
            corners.formUnion(.layerMaxXMinYCorner)
        }
        if bottomLeft {
            corners.formUnion(.layerMinXMaxYCorner)
        }
        if bottomRight {
            corners.formUnion(.layerMaxXMaxYCorner)
        }
        
        if cornerRadius > 0 && !topLeft && !topRight && !bottomLeft && !bottomRight {
            corners.formUnion(.layerMinXMinYCorner)
            corners.formUnion(.layerMaxXMinYCorner)
            corners.formUnion(.layerMinXMaxYCorner)
            corners.formUnion(.layerMaxXMaxYCorner)
        }

        layer.masksToBounds = cornerRadius > 0 && !isSetShadow
        layer.maskedCorners = corners
        layer.cornerRadius = cornerRadius
    }
    
    override var bounds: CGRect {
        didSet{
            updateCorners()
        }
    }

    @IBInspectable  var topLeft: Bool = false {
        didSet {
            updateCorners()
        }
    }
    @IBInspectable  var topRight: Bool = false {
        didSet {
            updateCorners()
        }
    }
    @IBInspectable  var bottomLeft: Bool = false {
        didSet {
            updateCorners()
        }
    }
    @IBInspectable  var bottomRight: Bool = false {
        didSet {
            updateCorners()
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            updateCorners()
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
            self.layer.setNeedsDisplay()
        }
    }

    @IBInspectable var normalBorderColor: UIColor? {
        didSet {
            self.layer.borderWidth = self.borderWidth
            self.layer.borderColor = normalBorderColor?.cgColor
            self.layer.setNeedsDisplay()
        }
    }

    @IBInspectable var normalColor: UIColor? {
        didSet {
            self.backgroundColor = normalColor
            self.layer.setNeedsDisplay()
        }
    }
    
    var isSetShadow: Bool = false
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
                isSetShadow = true
            } else {
                layer.shadowColor = nil
            }
        }
    }

    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
            isSetShadow = true
        }
    }

    @IBInspectable var shadowOffset: CGPoint {
        get {
            return CGPoint(x: layer.shadowOffset.width, y:layer.shadowOffset.height)
        }
        set {
            layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
            isSetShadow = true
        }

     }

    @IBInspectable var shadowBlur: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue / 2.0
            isSetShadow = true
        }
    }

    @IBInspectable var shadowSpread: CGFloat = 0 {
        didSet {
            if shadowSpread == 0 {
                layer.shadowPath = nil
            } else {
                let dx = -shadowSpread
                let rect = bounds.insetBy(dx: dx, dy: dx)
                layer.shadowPath = UIBezierPath(rect: rect).cgPath
                isSetShadow = true
            }
        }
    }
}

