//
//  ContentDetailCoordinator.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/01.
//

import Foundation

class ContentDetailCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    let service: TmdbService
    
    let content: _Content
    let heroID: String?
    
    init(content: _Content, heroID: String?, navigationController: UINavigationController, service: TmdbService) {
        self.content = content
        self.heroID = heroID
        self.navigationController = navigationController
        self.service = service
    }
    
    func start() {
        let viewModel = ContentDetailViewModel(with: content, heroID: heroID, coordinator: self)
        let viewController = ContentDetailViewController(viewModel: viewModel)
        
        navigationController.hero.navigationAnimationType = .fade
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showDetail(content: _Content, heroID: String?) {
        print("pushToDetail",content)
        let coordinator = ContentDetailCoordinator(content: content, heroID: heroID, navigationController: navigationController, service: service)
        coordinator.start()
    }
}
