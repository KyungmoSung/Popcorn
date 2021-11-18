//
//  MyPageViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/11/09.
//

import Foundation
import RxSwift

class MyPageViewModel: ViewModel {
    typealias Section = SectionItem<MyPageSection, MenuItemViewModel>

    struct Input {
        let ready: Observable<Void>
        let menuSelection: Observable<IndexPath>
    }
    
    struct Output {
        let needSignIn: Observable<Bool>
        let sectionItems: Observable<[Section]>
        let currentUser: Observable<User?>
        let selectedMenu: Observable<Menu>
    }
    
    private let coordinator: MyPageCoordinator
    
    init(networkService: TmdbService = TmdbAPI(), coordinator: MyPageCoordinator) {
        self.coordinator = coordinator
        
        super.init(networkService: networkService)
    }
    
    func transform(input: Input) -> Output {
        // 미로그인시 로그인으로 이동
        let needSignIn = AuthManager.shared.signResult
            .do(onNext: { [weak self] isSignIn in
                guard let self = self else { return }
                
                if !isSignIn {
                    self.coordinator.showSignIn()
                }
            })

        let sectionItems = input.ready
            .map { _ -> [Section] in
                let menus = Menu.allCases
                let viewModels = menus.map { MenuItemViewModel(menu: $0) }
                return [Section(section: .menu, items: viewModels)]
            }
        
        let selectedMenu = input.menuSelection
            .withLatestFrom(sectionItems) { indexPath, sections -> Menu in
                let viewModel = sections[indexPath.section].items[indexPath.row]
                return viewModel.menu
            }
            .do(onNext: { [weak self] menu in
                guard let self = self else { return }
                switch menu {
                case .favorite:
                    self.coordinator.showFavorite()
                case .watchlist:
                    self.coordinator.showWatchlist()
                case .rated:
                    self.coordinator.showRated()
                case .signOut:
                    AuthManager.shared.signOut()
                }
            })
                
        return Output(needSignIn: needSignIn,
                      sectionItems: sectionItems,
                      currentUser: AuthManager.shared.profileResultSubject,
                      selectedMenu: selectedMenu)
    }
}
