//
//  SignCoordinator.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/11/01.
//

import UIKit

class SignCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    let service: TmdbService
    
    init(navigationController: UINavigationController, service: TmdbService) {
        self.navigationController = navigationController
        self.service = service
    }
    
    func start() {
        let viewModel = SignViewModel(networkService: service, coordinator: self)
        let viewController = SignViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func startOnTabBar(currentCoordinator: Coordinator) {
        childCoordinators.append(currentCoordinator)
        
        let viewModel = SignViewModel(networkService: service, coordinator: self)
        let viewController = SignViewController(viewModel: viewModel)

        navigationController.viewControllers = [viewController]
    }
    
    func dismiss() {
        if !childCoordinators.isEmpty {
            childCoordinators.last?.start()
        } else if navigationController.topViewController is SignViewController {
            navigationController.popViewController(animated: true)
        }
    }
}
