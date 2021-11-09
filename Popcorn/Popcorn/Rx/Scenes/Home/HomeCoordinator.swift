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
        start(contentsType: .movies)
    }
    
    func start(contentsType: ContentsType) {
        let viewModel = HomeViewModel(contentsType: contentsType, networkService: service, coordinator: self)
        let viewController = _HomeViewController(viewModel: viewModel)
        viewController.hidesTabBar = false

        navigationController.viewControllers = [viewController]
    }
    
    func showDetail(content: _Content, heroID: String?) {
        let coordinator = ContentDetailCoordinator(content: content,
                                                   heroID: heroID,
                                                   navigationController: navigationController,
                                                   service: service)
        coordinator.start()
    }
    
    func showChartList(contents: [_Content], section: HomeSection) {
        let coordinator = ContentListCoordinator(contents: contents,
                                                 sourceSection: section,
                                                 navigationController: navigationController,
                                                 service: service)
        coordinator.start()
    }
}
