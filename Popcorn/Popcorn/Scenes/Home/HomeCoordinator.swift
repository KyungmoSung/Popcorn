//
//  HomeCoordinator.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/01.
//

import Foundation

class HomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    let service: TmdbService
    
    init(navigationController: UINavigationController, service: TmdbService) {
        self.navigationController = navigationController
        self.service = service
    }
    
    func start() {
        let viewModel = HomeViewModel(networkService: service, coordinator: self)
        let viewController = _HomeViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showDetail(content: _Content) {
        print("pushToDetail",content)
        let coordinator = ContentDetailCoordinator(content: content, navigationController: navigationController, service: service)
        coordinator.start()
    }
    
    func showChart(section: HomeSection) {
        print("pushToChart",section.title)
        let coordinator = HomeCoordinator(navigationController: navigationController, service: service)
        coordinator.start()
    }
}
