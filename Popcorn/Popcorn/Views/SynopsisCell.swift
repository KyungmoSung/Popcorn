//
//  SynopsisCell.swift
//  Popcorn
//
//  Created by Kyungmo on 2021/01/10.
//

import UIKit

class SynopsisCell: UICollectionViewCell {
    @IBOutlet weak var synopsisLb: UILabel!
    @IBOutlet weak var expandView: UIView!
    
    var gradient: CAGradientLayer?
    
    var isTagline: Bool = false {
        didSet {
            expandView.isHidden = isTagline
        }
    }
    
    var isExpand: Bool = false {
        didSet {
            guard !isTagline else {
                return
            }
            
            if isExpand {
                // 확장된 경우 가독성을 위해 마침표마다 한줄 추가
                UIView.transition(with: synopsisLb, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.synopsisLb.numberOfLines = 0
                    self.synopsisLb.text = self.synopsis?.replacingOccurrences(of: ". ", with: ".\n\n")
                })
                
                UIView.transition(with: self.expandView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    self.expandView.isHidden = self.isExpand
                })
            } else {
                // 축소된 경우 마지막에 더보기 라벨 표시
                UIView.transition(with: synopsisLb, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.synopsisLb.numberOfLines = 5
                    self.synopsisLb.text = self.synopsis
                })
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    UIView.transition(with: self.expandView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                        self.expandView.isHidden = self.isExpand
                    })
                }
            }
        }
    }

    var synopsis: String? {
        didSet {
            synopsisLb.attributedText = synopsis?.attributedString(font: UIFont.NanumSquare(size: 14, family: isTagline ? .ExtraBold : .Regular))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if gradient == nil {
            gradient = CAGradientLayer()
            
            let color = UIColor.secondarySystemGroupedBackground
            gradient!.colors = [color.withAlphaComponent(0).cgColor, color.cgColor]
            gradient!.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradient!.endPoint = CGPoint(x: 0.4, y: 1.0)
            gradient!.frame = CGRect(x: 0.0, y: 0.0, width: expandView.frame.size.width, height: expandView.frame.size.height)
            
            expandView.layer.insertSublayer(gradient!, at: 0)
        }
    }
}
