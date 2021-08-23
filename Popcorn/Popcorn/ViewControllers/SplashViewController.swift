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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Config.shared.fetch {
            self.present(self.groundTabBarController, animated: true, completion: nil)
        }
    }
    
    func setupTabBarController() {
        let homeVC = _HomeViewController()
        homeVC.viewModel = HomeViewModel()
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
            navi.hidesBottomBarWhenPushed = true
            return navi
        }
        
        groundTabBarController.modalPresentationStyle = .fullScreen
        
        groundTabBarController.tabBar.layer.shadowColor = UIColor.black.cgColor
        groundTabBarController.tabBar.layer.shadowOpacity = 0.1
        groundTabBarController.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        groundTabBarController.tabBar.layer.shadowRadius = 12 / 2.0
        
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = .systemBackground
        UITabBar.appearance().tintColor = .label
        UITabBar.appearance().isTranslucent = true
    }
}
