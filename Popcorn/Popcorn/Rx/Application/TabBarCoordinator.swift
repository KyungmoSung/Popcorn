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
        
        let movieHomeNavi = UINavigationController()
        movieHomeNavi.hero.isEnabled = true
        movieHomeNavi.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        let movieHomeCoordinator = HomeCoordinator(navigationController: movieHomeNavi,
                                                   service: service)
        movieHomeCoordinator.start(contentsType: .movies)
        
        let tvShowHomeNavi = UINavigationController()
        tvShowHomeNavi.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        let tvShowHomeCoordinator = HomeCoordinator(navigationController: tvShowHomeNavi,
                                                    service: service)
        tvShowHomeCoordinator.start(contentsType: .tvShows)
        
        let homeNC3 = UINavigationController()
        homeNC3.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 2)
        let homeCoordinator3 = RecommendCoordinator(navigationController: homeNC3,
                                                    service: service)
        homeCoordinator3.start()
        
        let myPageNavi = UINavigationController()
        myPageNavi.tabBarItem = UITabBarItem(tabBarSystemItem: .more , tag: 3)
        let myPageCoordinator = MyPageCoordinator(navigationController: myPageNavi,
                                                  service: service)
        myPageCoordinator.start()
        
        tabBarController.viewControllers = [movieHomeNavi, tvShowHomeNavi, homeNC3, myPageNavi]
        navigationController.viewControllers = [tabBarController]
    }
}
