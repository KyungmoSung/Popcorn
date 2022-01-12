//
//  RateCoordinator.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/11/19.
//

import Foundation
import UIKit

class RateCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    let service: TmdbService
    let content: Content
    let rated: Double?
    var completion: (() -> Void)?
    
    init(content: Content, rated: Double?, navigationController: UINavigationController, service: TmdbService) {
        self.content = content
        self.rated = rated
        self.navigationController = navigationController
        self.service = service
    }
    
    func start() {
        let viewModel = RateViewModel(with: content, rated: rated, networkService: service, coordinator: self)
        let viewController = RateViewController(viewModel: viewModel)
        viewController.hidesNavigationBar = true
        viewController.hidesTabBar = false

        viewController.modalPresentationStyle = .overFullScreen
        navigationController.present(viewController, animated: true, completion: nil)
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true, completion: completion)
    }
}
