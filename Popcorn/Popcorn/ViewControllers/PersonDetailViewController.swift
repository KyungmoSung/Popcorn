//
//  PersonDetailViewController.swift
//  Popcorn
//
//  Created by Kyungmo on 2021/01/31.
//

import UIKit

class PersonDetailViewController: BaseViewController {
    @IBOutlet private weak var blurPosterIv: UIImageView!
    @IBOutlet weak var profileIv: UIImageView!
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    var person: Person!
    
    var profileHeroId: String?
    var profileHeroImage: UIImage?
    
    var sectionItems: [SectionItem] = []

    convenience init(person: Person) {
        self.init()
        self.person = person
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation(title: person.name)
        
        for sectionType in Section.Detail.Person.allCases {
            if sectionType == .title {
                sectionItems.append(SectionItem(sectionType, items: [person]))
            } else {
                sectionItems.append(SectionItem(sectionType))
            }
        }
        
        requestInfo(for: Section.Detail.Person.allCases)
        
        setupUI()
    }
    
    func updateSectionItems(_ items: [ListDiffable], at index: Int) {
        let sectionItem = self.sectionItems[index]
        sectionItem.items = items
        
        if let sc = self.adapter.sectionController(for: sectionItem) as? DetailHorizontalSectionController {
            sc.collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                batchContext.reload(sc)
            })
        }
    }
    
    func requestInfo(for sections: [SectionType]) {
        for (index, section) in sections.enumerated() {
            switch section {
            case let personSection as Section.Detail.Person:
                switch personSection {
                case .title:
                    APIManager.request(AppConstants.API.Person.getDetails(person.id), method: .get, params: nil, responseType: Person.self) { (result) in
                        switch result {
                        case .success(let person):
                            self.person = person
                            self.updateSectionItems([person], at: index)
                            self.updateSectionItems(person.detailInfos, at: Section.Detail.Person.detail.rawValue)

                            var biographyInfo: [ListDiffable] = []
                            if let biography = person.biography, !biography.isEmpty {
                                biographyInfo.append(biography as ListDiffable)
                            }
                            self.updateSectionItems(biographyInfo, at: Section.Detail.Person.biography.rawValue)

                        case .failure(let error):
                            Log.d(error)
                        }
                    }
                case .biography:
                    break
                case .detail:
                    break
                case .movies:
                    APIManager.request(AppConstants.API.Person.getMovieCredits(person.id), method: .get, params: nil, responseType: CreditsResponse<MovieCredit>.self) { (result) in
                        switch result {
                        case .success(let credits):
                            let cast = credits.cast ?? []
                            let crew = credits.crew ?? []
                            
                            cast.forEach{ $0.department = "Acting" }
                            
                            let movieCredits = cast + crew
                            self.updateSectionItems(movieCredits, at: index)
                        case .failure(let error):
                            Log.d(error)
                        }
                    }
                case .tvShows:
                    APIManager.request(AppConstants.API.Person.getTvCredits(person.id), method: .get, params: nil, responseType: CreditsResponse<TVShowCredit>.self) { (result) in
                        switch result {
                        case .success(let credits):
                            let cast = credits.cast ?? []
                            let crew = credits.crew ?? []
                                                        
                            let tvCredits = cast + crew
                            self.updateSectionItems(tvCredits, at: index)
                        case .failure(let error):
                            Log.d(error)
                        }
                    }
                case .image:
                    APIManager.request(AppConstants.API.Person.getImages(person.id), method: .get, params: nil, responseType: ListResponse.self) { (result) in
                        switch result {
                        case .success(let response):
                            let profiles = response.profiles ?? []
                            self.updateSectionItems(profiles, at: index)
                        case .failure(let error):
                            Log.d(error)
                        }
                    }
                }
            default:
                break
            }
        }
    }
        
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setTransparent(true)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.clear]

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setTransparent(false)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.label]
    }
    
    func setupUI() {
        profileIv.hero.id = profileHeroId
        
        DispatchQueue.main.async {
            self.profileIv.image = self.profileHeroImage
            self.profileIv.applyShadow()
            
            self.blurPosterIv.image = self.profileHeroImage
            self.blurPosterIv.applyBlur(style: .regular)

            if let path = self.person?.profilePath, let url = URL(string: AppConstants.Domain.tmdbImage + path), self.profileIv.image == nil {
                Nuke.loadImage(with: url, options: ImageLoadingOptions.fadeIn, into: self.profileIv, completion: { result in
                    switch result {
                    case .success(let response):
                        self.blurPosterIv.image = response.image
                    case .failure(_):
                        break
                    }
                })
            }
        }
        
        setupFloatingPanel()
    }
    
    func setupFloatingPanel() {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let contentVC = UICollectionViewController(collectionViewLayout: layout)
        contentVC.collectionView.backgroundColor = .secondarySystemGroupedBackground

        adapter.collectionView = contentVC.collectionView
        adapter.dataSource = self

        let fpc = FloatingPanelController(delegate: self)
        fpc.layout = FloatingLayout()
        fpc.set(contentViewController: contentVC)
        fpc.track(scrollView: contentVC.collectionView)
        fpc.addPanel(toParent: self)
        
        let shadow = SurfaceAppearance.Shadow()
        shadow.color = UIColor.black
        shadow.offset = CGSize(width: 0, height: 16)
        shadow.radius = 20
        shadow.spread = 0
        shadow.opacity = 1
        
        let appearance = SurfaceAppearance()
        appearance.shadows = [shadow]
        appearance.cornerRadius = 20
        appearance.backgroundColor = .clear

        fpc.surfaceView.appearance = appearance

        fpc.view.hero.modifiers = [
            .when({ (context) -> Bool in
                return context.isPresenting && context.isAppearing // 화면이 처음 보여지는 경우에만 애니메이션 적용
            }, .translate(y: 500), .spring(stiffness: 80, damping: 12))
        ]
    }
}

extension PersonDetailViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return sectionItems
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return DetailHorizontalSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension PersonDetailViewController: FloatingPanelControllerDelegate {
    func floatingPanelWillEndDragging(_ fpc: FloatingPanelController, withVelocity velocity: CGPoint, targetState: UnsafeMutablePointer<FloatingPanelState>) {
        switch targetState.pointee {
        case .full:
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.label]
            }
        case .half:
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.clear]
            }
        default:
            break
        }
    }
}
