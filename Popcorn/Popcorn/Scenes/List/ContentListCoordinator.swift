//
//  ContentListCoordinator.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/13.
//

import UIKit

class ContentListCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    let sectionType: ListSection
    let service: TmdbService
    
    init(sectionType: ListSection, navigationController: UINavigationController, service: TmdbService) {
        self.sectionType = sectionType
        self.navigationController = navigationController
        self.service = service
    }
    
    func start() {
        let viewModel = ContentListViewModel(with: sectionType, networkService: service, coordinator: self)
        let viewController = ContentListViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showDetail(content: Content, heroID: String?) {
        let coordinator = ContentDetailCoordinator(content: content,
                                                   heroID: heroID,
                                                   navigationController: navigationController,
                                                   service: service)
        coordinator.start()
    }
}
