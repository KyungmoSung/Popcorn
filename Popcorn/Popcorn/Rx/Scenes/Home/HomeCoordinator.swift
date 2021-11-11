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
    let contentsType: ContentsType
    
    init(contentsType: ContentsType, navigationController: UINavigationController, service: TmdbService) {
        self.contentsType = contentsType
        self.navigationController = navigationController
        self.service = service
    }
    
    func start() {
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
        let listSection: ListSection
        switch section {
        case .movie(let chart):
            listSection = .movieChart(chart)
        case .tvShow(let chart):
            listSection = .tvShowChart(chart)
        }
        
        let coordinator = ContentListCoordinator(contents: contents,
                                                 sectionType: listSection,
                                                 navigationController: navigationController,
                                                 service: service)
        coordinator.start()
    }
}
