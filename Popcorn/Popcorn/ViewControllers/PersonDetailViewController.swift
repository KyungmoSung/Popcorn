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
    
    var person: Person!
    var profileHeroId: String?
    var profileImage: UIImage?

    convenience init(person: Person) {
        self.init()
        self.person = person
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation(title: person.name)
        
        self.blurPosterIv.applyBlur(style: .regular)
        self.profileIv.applyShadow()
        
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

        profileIv.hero.id = profileHeroId
        profileIv.heroModifiers = [.spring(stiffness: 90, damping: 15)]

        setupFloatingPanel()
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
    
    func setupFloatingPanel() {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let contentVC = UICollectionViewController(collectionViewLayout: layout)
        contentVC.collectionView.backgroundColor = .secondarySystemGroupedBackground

//        collectionView = contentVC.collectionView
//        adapter.collectionView = contentVC.collectionView
//        adapter.dataSource = self

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
