//
//  MyPageViewModel.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/11/09.
//

import Foundation
import RxSwift

class MyPageViewModel: ViewModel {
    typealias Section = _SectionItem<MyPageSection, MenuItemViewModel>

    struct Input {
        let ready: Observable<Void>
        let menuSelection: Observable<IndexPath>
    }
    
    struct Output {
        let sectionItems: Observable<[Section]>
        let selectedMenu: Observable<Menu>
    }
    
    private let coordinator: MyPageCoordinator
    
    init(networkService: TmdbService = TmdbAPI(), coordinator: MyPageCoordinator) {
        self.coordinator = coordinator
        
        super.init(networkService: networkService)
    }
    
    func transform(input: Input) -> Output {
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
                }
            })
        
        return Output(sectionItems: sectionItems, selectedMenu: selectedMenu)
    }
}
