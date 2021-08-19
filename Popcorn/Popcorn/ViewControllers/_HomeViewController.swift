//
//  _HomeViewController.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/04.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class _HomeViewController: UIViewController {
    typealias HomeSection = _Section<_SectionType.Home, _Content>
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var sections: [HomeSection] = []
    var relay = BehaviorRelay<[HomeSection]>(value: [])
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchContents()
        setupUI()
    }
    
    func fetchContents() {
        let params: [String: Any] = [
            "page": 1
        ]
        
        APIManager.request(AppConstants.API.Movie.getPopular, method: .get, params: params, responseType: PageResponse<_Movie>.self) { (result) in
            switch result {
            case .success(let response):
                guard let items = response.results else {
                    return
                }
                
                self.updateSection(.movie(.popular), items: items)
            case .failure(let error):
                Log.d(error)
            }
        }
        
        APIManager.request(AppConstants.API.Movie.getTopRated, method: .get, params: params, responseType: PageResponse<_Movie>.self) { (result) in
            switch result {
            case .success(let response):
                guard let items = response.results else {
                    return
                }
                
                self.updateSection(.movie(.topRated), items: items)
            case .failure(let error):
                Log.d(error)
            }
        }
    }
    
    func updateSection(_ sectionType: _SectionType.Home, items: [_Content]) {
        if let index = sections.firstIndex(where: { $0.sectionType == sectionType }) {
            sections[index].items.append(contentsOf: items)
        } else {
            sections.append(HomeSection(sectionType: sectionType, items: items))
        }
        
        relay.accept(sections)
    }
    
    func setupUI() {
        collectionView.collectionViewLayout = createCompositionalLayout()
        collectionView.register(UINib(nibName: "HomePosterCell", bundle: nil), forCellWithReuseIdentifier: "HomePosterCell")
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<HomeSection> { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePosterCell", for: indexPath) as? HomePosterCell else {
                return UICollectionViewCell()
            }
            
            cell.title = item.title
            cell.posterImgPath = item.posterPath
            cell.voteAverage = item.voteAverage
            
            return cell
        }
        
        relay
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // 그룹
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(160),
                                               heightDimension: .absolute(240+30))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 2)
        
        // 섹션
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
