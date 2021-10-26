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
    
    let id: Int?
    let contents: [_Content]?
    let credits: [Person]?
    let sourceSection: _SectionType
    let service: TmdbService
    
    init(contents: [_Content], id: Int? = nil, sourceSection: _SectionType, navigationController: UINavigationController, service: TmdbService) {
        self.id = id
        self.contents = contents
        self.sourceSection = sourceSection
        self.navigationController = navigationController
        self.service = service
        self.credits = nil
    }
    
    init(credits: [Person], sourceSection: _SectionType, navigationController: UINavigationController, service: TmdbService) {
        self.credits = credits
        self.sourceSection = sourceSection
        self.navigationController = navigationController
        self.service = service
        self.id = nil
        self.contents = nil
    }
    
    func start() {
        var viewModel: BaseViewModel?
        
        if let contents = contents {
            viewModel = ContentListViewModel(with: contents, id: id, sourceSection: sourceSection, networkService: service, coordinator: self)
        } else if let credits = credits {
            viewModel = CreditListViewModel(with: credits, sourceSection: sourceSection, networkService: service, coordinator: self)
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
