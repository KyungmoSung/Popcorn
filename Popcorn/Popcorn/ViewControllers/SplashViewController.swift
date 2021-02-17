//
//  SplashViewController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/11/02.
//

import UIKit

class SplashViewController: UIViewController {
    let groundTabBarController = UITabBarController()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBarController()
        
        Config.shared.fetch {
            self.present(self.groundTabBarController, animated: true, completion: nil)
        }
    }
    
    func setupTabBarController() {
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        
        let rankingVC = UIViewController()
        rankingVC.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)

        let settingVC = UIViewController()
        settingVC.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 2)

        let mainVC = UIViewController()
        mainVC.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 3)
        
        
        let viewControllers = [homeVC, rankingVC, settingVC, mainVC]
        
        groundTabBarController.viewControllers = viewControllers.map {
            let navi = UINavigationController(rootViewController: $0)
            navi.hero.isEnabled = true
            return navi
        }
        
        groundTabBarController.modalPresentationStyle = .fullScreen
        groundTabBarController.tabBar.tintColor = .label
        groundTabBarController.tabBar.barTintColor = .secondarySystemBackground
        groundTabBarController.tabBar.layer.masksToBounds = true
        groundTabBarController.tabBar.isTranslucent = true
        groundTabBarController.tabBar.barStyle = .default
        groundTabBarController.tabBar.layer.cornerRadius = 25
        groundTabBarController.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
    }
}
