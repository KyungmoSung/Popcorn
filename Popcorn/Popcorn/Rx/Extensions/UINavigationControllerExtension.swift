//
//  UINavigationControllerExtension.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/12/15.
//

import UIKit

extension UINavigationController {
    /// 네비게이션바 투명 설정
    func setTransparent(_ transparent: Bool) {
        if transparent {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.isTranslucent = true
            view.backgroundColor = .clear
        } else {
            navigationBar.setBackgroundImage(nil, for: .default)
            navigationBar.shadowImage = nil
            view.backgroundColor = .systemBackground
        }
        navigationBar.layoutIfNeeded()
    }
}
