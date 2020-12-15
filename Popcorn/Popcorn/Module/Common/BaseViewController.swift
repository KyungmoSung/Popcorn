//
//  BaseViewController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/12/15.
//

import UIKit

class BaseViewController: UIViewController {
    var navigationBarIsHidden: Bool = true
    var tabBarIsHidden: Bool = false
    var transparentNavigationBarOffsetY: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = navigationBarIsHidden
        tabBarController?.tabBar.isHidden = tabBarIsHidden
    }
    
    func setNavigation(title: String?, navigationBar: Bool = true, tabBar: Bool = false) {
        self.title = title
        navigationBarIsHidden = !navigationBar
        tabBarIsHidden = !tabBar
    }
}
