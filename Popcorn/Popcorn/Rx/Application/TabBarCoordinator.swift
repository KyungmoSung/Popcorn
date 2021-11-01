//
//  TabBarCoordinator.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/01.
//

import UIKit

class TabBarCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    let service: TmdbService

    init(navigationController: UINavigationController, service: TmdbService) {
        self.navigationController = navigationController
        self.service = service
    }
    
    func start() {
        let tabBarController = UITabBarController()
        
        tabBarController.modalPresentationStyle = .fullScreen
        tabBarController.tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBarController.tabBar.layer.shadowOpacity = 0.1
        tabBarController.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBarController.tabBar.layer.shadowRadius = 12 / 2.0
        
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = .systemBackground
        UITabBar.appearance().tintColor = .label
        UITabBar.appearance().isTranslucent = true
        
        let homeNC = UINavigationController()
        homeNC.hero.isEnabled = true
        homeNC.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        let homeCoordinator = HomeCoordinator(navigationController: homeNC,
                                              service: service)
        
        let recommendNC = UINavigationController()
        recommendNC.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        let recommendCoordinator = RecommendCoordinator(navigationController: recommendNC,
                                              service: service)
        
        let homeNC3 = UINavigationController()
        homeNC3.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 2)
        let homeCoordinator3 = HomeCoordinator(navigationController: homeNC3,
                                              service: service)
        
        tabBarController.viewControllers = [homeNC, recommendNC, homeNC3]

        navigationController.viewControllers = [tabBarController]
        
        homeCoordinator.start()
        recommendCoordinator.start()
        homeCoordinator3.start()
    }
}
