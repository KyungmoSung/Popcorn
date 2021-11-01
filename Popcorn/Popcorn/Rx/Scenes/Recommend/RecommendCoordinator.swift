//
//  RecommendCoordinator.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/11/01.
//

import Foundation

class RecommendCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    let service: TmdbService
    
    init(navigationController: UINavigationController, service: TmdbService) {
        self.navigationController = navigationController
        self.service = service
    }
    
    func start() {
        let viewModel = RecommendViewModel(networkService: service, coordinator: self)
        let viewController = RecommendViewController(viewModel: viewModel)
        viewController.hidesNavigationBar = true
        viewController.hidesTabBar = false

        navigationController.viewControllers = [viewController]
    }
    
    func showSignIn() {
        let coordinator = SignCoordinator(navigationController: navigationController, service: service)
        coordinator.start()
    }
}
