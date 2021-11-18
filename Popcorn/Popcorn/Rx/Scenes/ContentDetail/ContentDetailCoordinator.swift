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
    var viewController: UIViewController?
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
        viewController = ContentDetailViewController(viewModel: viewModel)
        
        navigationController.hero.navigationAnimationType = .fade
        navigationController.pushViewController(viewController!, animated: true)
    }
    
    func showDetail(content: _Content, heroID: String?) {
        let coordinator = ContentDetailCoordinator(content: content,
                                                   heroID: heroID,
                                                   navigationController: navigationController,
                                                   service: service)
        coordinator.start()
    }
    
    func showList(section: DetailSection) {
        let coordinator = ContentListCoordinator(sectionType: listSection(for: section),
                                                 navigationController: navigationController,
                                                 service: service)
        coordinator.start()
    }
    
    func showRatePopup(activityItems: [Any]) {
        guard let viewController = viewController else { return }
        
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = viewController.view

        viewController.present(activityVC, animated: true, completion: nil)

    }
                                                 
    func listSection(for detailSection: DetailSection) -> ListSection {
        switch detailSection {
        case .movie(let info):
            return .movieInformation(info, content.id)
        case .tvShow(let info):
            return .tvShowInformation(info, content.id)
        }
    }
}
