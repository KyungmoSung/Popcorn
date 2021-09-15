//
//  SplashCoordinator.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/01.
//

import UIKit

class SplashCoodinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    let service: TmdbService
    
    init(navigationController: UINavigationController, service: TmdbService) {
        self.navigationController = navigationController
        self.service = service
    }
    
    func start() {
        let vc = SplashViewController()
        vc.hidesNavigationBar = true
        vc.viewModel = SplashViewModel(networkService: service, coordinator: self)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showTabBar() {
        let coordinator = TabBarCoordinator(navigationController: navigationController, service: service)
        coordinator.start()
    }
    
}
