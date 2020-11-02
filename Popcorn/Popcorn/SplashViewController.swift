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
        present(groundTabBarController, animated: true, completion: nil)
    }
    
    func setupTabBarController() {
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        
//        let rankingVC = RankingViewController()
//        rankingVC.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 1)
//
//        let settingVC = SettingViewController()
//        settingVC.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 2)
//
//        let mainVC = MainViewController()
//        mainVC.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 3)
        
        
        let viewControllers = [homeVC]
        
        groundTabBarController.viewControllers = viewControllers.map {
            let navi = UINavigationController(rootViewController: $0)
            navi.navigationBar.prefersLargeTitles = true
            return navi
        }
        
        groundTabBarController.modalPresentationStyle = .fullScreen
    }
}
