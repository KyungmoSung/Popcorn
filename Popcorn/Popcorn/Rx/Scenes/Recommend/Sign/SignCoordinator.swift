//
//  SignCoordinator.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/11/01.
//

import Foundation

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
    
    func dismiss() {
        if navigationController.topViewController is SignViewController {
            navigationController.popViewController(animated: true)
        }
    }
}
