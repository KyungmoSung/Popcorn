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
    let accountState: AccountStates
    
    init(content: Content, accountState: AccountStates, navigationController: UINavigationController, service: TmdbService) {
        self.content = content
        self.accountState = accountState
        self.navigationController = navigationController
        self.service = service
    }
    
    func start() {
        let viewModel = RateViewModel(with: content, accountState: accountState, networkService: service, coordinator: self)
        let viewController = RateViewController(viewModel: viewModel)
        viewController.hidesNavigationBar = true
        viewController.hidesTabBar = false

        viewController.modalPresentationStyle = .overFullScreen
        navigationController.present(viewController, animated: true, completion: nil)
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true)
    }
}
