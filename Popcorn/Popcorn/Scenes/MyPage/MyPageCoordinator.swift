//
//  MyPageCoordinator.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/11/09.
//

import UIKit

class MyPageCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    let service: TmdbService

    init(navigationController: UINavigationController, service: TmdbService) {
        self.navigationController = navigationController
        self.service = service
    }

    func start() {
        let viewModel = MyPageViewModel(networkService: service, coordinator: self)
        let viewController = MyPageViewController(viewModel: viewModel)
        viewController.hidesTabBar = false
        
        navigationController.viewControllers = [viewController]
    }
    
    func showSignIn() {
        let coordinator = SignCoordinator(navigationController: navigationController,
                                          service: service)
        coordinator.startOnTabBar(currentCoordinator: self)
    }
    
    func showFavorite(){
        let coordinator = ContentListCoordinator(sectionType: .favorites,
                                                 navigationController: navigationController,
                                                 service: service)
        coordinator.start()
    }
    
    func showWatchlist(){
        Log.d("showWatchlist")
    }
    
    func showRated(){
        Log.d("showRated")
    }
}
