//
//  ContentListCoordinator.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/13.
//

import Foundation

class ContentListCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    let sectionType: ListSection
    let contents: [_Content]?
    let credits: [Person]?
    let service: TmdbService
    
    init(contents: [_Content], sectionType: ListSection, navigationController: UINavigationController, service: TmdbService) {
        self.sectionType = sectionType
        self.contents = contents
        self.navigationController = navigationController
        self.service = service
        self.credits = nil
    }
    
    init(credits: [Person], sectionType: ListSection, navigationController: UINavigationController, service: TmdbService) {
        self.credits = credits
        self.sectionType = sectionType
        self.navigationController = navigationController
        self.service = service
        self.contents = nil
    }
    
    func start() {
        var viewModel: BaseViewModel?
        
        if let contents = contents {
            viewModel = ContentListViewModel(with: contents, sectionType: sectionType, networkService: service, coordinator: self)
        } else if let credits = credits {
            viewModel = CreditListViewModel(with: credits, sectionType: sectionType, networkService: service, coordinator: self)
        }
        
        if let viewModel = viewModel {
            let viewController = ContentListViewController(viewModel: viewModel)            
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    func showDetail(content: _Content, heroID: String?) {
        let coordinator = ContentDetailCoordinator(content: content,
                                                   heroID: heroID,
                                                   navigationController: navigationController,
                                                   service: service)
        coordinator.start()
    }
}
