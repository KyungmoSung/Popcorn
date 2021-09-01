//
//  AppCoordinator.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/30.
//

import Foundation

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    let window: UIWindow
    let service: TmdbService
    
    init(in window: UIWindow, service: TmdbService) {
        self.window = window
        self.service = service
        self.navigationController = UINavigationController()
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        showSplash()
    }
    
    func showSplash() {
        let coordinator = SplashCoodinator(navigationController: navigationController, service: service)
        coordinator.start()
    }
}
