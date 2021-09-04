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
    
    init(content: _Content, navigationController: UINavigationController, service: TmdbService) {
        self.content = content
        self.navigationController = navigationController
        self.service = service
    }
    
    func start() {
        var viewController: UIViewController?
        
        switch content {
        case let movie as _Movie:
            let viewModel = ContentDetailViewModel(with: movie, coordinator: self)
            viewController = ContentDetailViewController(viewModel: viewModel)
            
        case let tvShow as _TVShow:
            let viewModel = ContentDetailViewModel(with: tvShow, coordinator: self)
            viewController = ContentDetailViewController(viewModel: viewModel)
        default:
            return
        }
        
        if let viewController = viewController {
            navigationController.pushViewController(viewController, animated: true)
        } else {
            Log.e("Type casting failed")
        }
    }
}
