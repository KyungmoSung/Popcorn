//
//  HorizontalSectionController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import UIKit

class DetailHorizontalSectionController: ListSectionController {
    
    private var sectionItem: SectionItem?
    var isExpand: Bool = false
    
    lazy var cellAdapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self.viewController)
        adapter.dataSource = self
        return adapter
    }()
    
    lazy var headerAdapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self.viewController)
        adapter.dataSource = self
        return adapter
    }()
    
    override init() {
        super.init()
        supplementaryViewSource = self
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, let sectionItem = sectionItem, sectionItem.items.count > 0 else {
            return .zero
        }
        
        switch sectionItem.sectionType {
        case Section.Detail.Movie.synopsis, Section.Detail.TVShow.synopsis:
            if let items = sectionItem.items as? [String], items.count > 0 {
                // 텍스트 높이 계산
                let totalHeight: CGFloat = items
                    .enumerated()
                    .map {
                        let isTagline = items.count > 1 && $0.offset == 0
                        let numberOfLines = isTagline ? 0 : (isExpand ? 0 : 5)
                        let font = UIFont.NanumSquare(size: 14, family: isTagline ? .ExtraBold : .Regular)
                        
                        let text = isTagline ? $0.element : (isExpand ? $0.element.replacingOccurrences(of: ". ", with: ".\n\n") : $0.element)
                        
                        return text.height(for: font, numberOfLines: numberOfLines, width: context.containerSize.width - 60)
                    }
                    .reduce(0) { $0 + $1 }
                return CGSize(width: context.containerSize.width, height: totalHeight)
            }
        default:
            break
        }
        
        return CGSize(width: context.containerSize.width, height: sectionItem.sectionType.height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext, let sectionType = sectionItem?.sectionType else {
            return UICollectionViewCell()
        }
        
        let cell: EmbeddedCollectionViewCell = context.dequeueReusableCell(for: self, at: index)
        cellAdapter.collectionView = cell.collectionView
        
        if let layout = cell.collectionView.collectionViewLayout as? PagingCollectionViewLayout {
            switch sectionType {
            case Section.Detail.Movie.detail, Section.Detail.TVShow.detail: // 가로 스크롤 & 자동 넓이
                layout.scrollDirection = .horizontal
                cell.collectionView.isScrollEnabled = true
                layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            case Section.Detail.Movie.synopsis, Section.Detail.TVShow.synopsis: // 세로 스크롤 & 자동 높이
                layout.scrollDirection = .vertical
                cell.collectionView.isScrollEnabled = false
                layout.estimatedItemSize = .zero
            default: // 가로 스크롤
                layout.scrollDirection = .horizontal
                cell.collectionView.isScrollEnabled = true
                layout.estimatedItemSize = .zero
            }
            
            cell.collectionView.collectionViewLayout.invalidateLayout()
        }
        return cell
    }
    
    override func didUpdate(to object: Any) {
        sectionItem = object as? SectionItem
    }
}

extension DetailHorizontalSectionController: ListSupplementaryViewSource {
    func supportedElementKinds() -> [String] {
        return [UICollectionView.elementKindSectionHeader]
    }
    
    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        guard let context = collectionContext, let sectionItem = sectionItem, sectionItem.items.count > 0 else {
            return .zero
        }
        
        var size: CGSize = context.containerSize
        
        switch sectionItem.sectionType {
        case Section.Detail.Movie.title, Section.Detail.TVShow.title:
            var title: String = ""
            switch sectionItem.items[section] {
            case let movie as Movie:
                title = movie.title
            case let tvShow as TVShow:
                title = tvShow.name
            default:
                break
            }
            
            let titleHeight = title.height(for: .NanumSquare(size: 30, family: .ExtraBold), lineSpacing: 0, numberOfLines: 0, width: context.containerSize.width - 132)
            size.height = 223 + ceil(titleHeight)
        case Section.Detail.Movie.image, Section.Detail.TVShow.image:
            size.height = 121
        default:
            size.height = 85
        }
        
        return size
    }
    
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        guard let context = collectionContext, let sectionItem = sectionItem else {
            return UICollectionReusableView()
        }
        
        switch sectionItem.sectionType {
        case Section.Detail.Movie.title, Section.Detail.TVShow.title:
            let headerView: ContentsHeaderVIew = context.dequeueReusableSupplementaryXibView(ofKind: UICollectionView.elementKindSectionHeader, for: self, at: index)
            
            switch sectionItem.items[section] {
            case let movie as Movie:
                headerView.title = movie.title
                headerView.originalTitle = movie.originalTitle
                headerView.year = movie.releaseDate?.dateValue()?.toString("yyyy")
                headerView.voteAverage = movie.voteAverage
            case let tvShow as TVShow:
                headerView.title = tvShow.name
                headerView.originalTitle = tvShow.originalName
                headerView.year = tvShow.firstAirDate?.dateValue()?.toString("yyyy")
                headerView.voteAverage = tvShow.voteAverage
            default:
                break
            }
            
            headerAdapter.collectionView = headerView.genreCollectionView

            return headerView
        case Section.Detail.Movie.image, Section.Detail.TVShow.image:
            let headerView: SectionHeaderView = context.dequeueReusableSupplementaryXibView(ofKind: UICollectionView.elementKindSectionHeader, for: self, at: index)
            
            headerView.index = sectionItem.sectionType.rawValue
            headerView.title = sectionItem.sectionType.title
            headerView.expandable = true
            headerView.delegate = self
            headerView.tabCollectionView.isHidden = false
            
            headerAdapter.collectionView = headerView.tabCollectionView
            
            return headerView
        default:
            let headerView: SectionHeaderView = context.dequeueReusableSupplementaryXibView(ofKind: UICollectionView.elementKindSectionHeader, for: self, at: index)
            
            headerView.index = sectionItem.sectionType.rawValue
            headerView.title = sectionItem.sectionType.title
            if let type = sectionItem.sectionType as? Section.Detail.Movie, type == .synopsis || type == .detail {
                headerView.expandable = false
                headerView.delegate = nil
            } else if let type = sectionItem.sectionType as? Section.Detail.TVShow, type == .synopsis || type == .detail {
                headerView.expandable = false
                headerView.delegate = nil
            } else {
                headerView.expandable = true
                headerView.delegate = self
            }
            
            headerView.tabCollectionView.isHidden = true
            
            headerAdapter.collectionView = nil
            
            return headerView
        }
    }
}

extension DetailHorizontalSectionController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard let sectionItem = sectionItem, let vc = viewController as? ContentsDetailViewController else {
            return []
        }
        
        if listAdapter == cellAdapter {
            switch sectionItem.sectionType {
            case Section.Detail.Movie.image, Section.Detail.TVShow.image: // 선택된 이미지타입만 필터링 (포스터/배경)
                if let items = sectionItem.items as? [ImageInfo] {
                    let filterItem = items.filter{ return $0.type == vc.selectedImageType }
                    return [SectionItem(sectionItem.sectionType, items: filterItem)]
                }
            default:
                return [sectionItem]
            }
        } else {
            switch sectionItem.sectionType {
            case Section.Detail.Movie.title, Section.Detail.TVShow.title:
                if let item = sectionItem.items.first as? Contents, let genres = item.genres {
                    let tags = genres.map{ Tag(id: $0.id, name: $0.name, isLoading: $0.isLoading) }
                    return tags as [ListDiffable]
                }
            break
            case Section.Detail.Movie.image, Section.Detail.TVShow.image:
                let titles = ImageType.allCases.map{ $0.title }
                return titles as [ListDiffable]
            default:
                break
            }
        }
        
        return []
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        guard let sectionItem = sectionItem else {
            return ListSectionController()
        }
        
        if listAdapter == cellAdapter {
            switch sectionItem.sectionType {
            case Section.Detail.Movie.detail, Section.Detail.TVShow.detail:
                return InfoCardSectionController()
            case Section.Detail.Movie.synopsis, Section.Detail.TVShow.synopsis:
                return SynopsisSectionController(delegate: self)
            case Section.Detail.Movie.image, Section.Detail.Movie.video, Section.Detail.TVShow.image, Section.Detail.TVShow.video:
                return MediaSectionController(direction: .horizontal)
            case Section.Detail.Movie.credit, Section.Detail.TVShow.credit:
                return CreditSectionController(direction: .horizontal)
            case Section.Detail.Movie.recommendation, Section.Detail.Movie.similar, Section.Detail.TVShow.recommendation, Section.Detail.TVShow.similar:
                return PosterSectionController(type: .poster, direction: .horizontal)
            case Section.Detail.Movie.review, Section.Detail.TVShow.review:
                return ReviewSectionController(direction: .horizontal)
            default:
                break
            }
        } else {
            switch sectionItem.sectionType {
            case Section.Detail.Movie.title, Section.Detail.TVShow.title:
                return TextTagSectionController(delegate: self)
            case Section.Detail.Movie.image, Section.Detail.TVShow.image:
                return TextTabSectionController(delegate: self)
            default:
                break
            }
        }
        
        return ListSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension DetailHorizontalSectionController: TextTabDelegate {
    func didSelectTab(index: Int) {
        guard let type = ImageType(rawValue: index), let vc = viewController as? ContentsDetailViewController, vc.selectedImageType != type else {
            return
        }
        
        vc.selectedImageType = type
        
        // collectionView update/scroll fade 애니메이션 적용
        UIView.animate(withDuration: 0.2) {
            self.cellAdapter.collectionView?.alpha = 0
        } completion: { (_) in
            if let object = self.cellAdapter.objects().first {
                self.cellAdapter.scroll(to: object, supplementaryKinds: nil, scrollDirection: .horizontal, scrollPosition: .left, animated: false)
            }
            self.cellAdapter.performUpdates(animated: false) { (_) in
                UIView.animate(withDuration: 0.2) {
                    self.cellAdapter.collectionView?.alpha = 1
                }
            }
        }
        
        var objects = headerAdapter.objects()
        objects.remove(at: index)
        headerAdapter.reloadObjects(objects)
    }
}

extension DetailHorizontalSectionController: TextTagDelegate {
    func didSelectTag(index: Int) {
        if let items = sectionItem?.items as? [String], items.count > index {
            print(items[index])
        }
    }
}

extension DetailHorizontalSectionController: SectionHeaderViewDelegate {
    func didTapExpandBtn(index: Int) {
        guard let sectionItem = sectionItem else {
            return
        }
        let vc = ContentsListViewController()
        vc.title = sectionItem.sectionType.title
        vc.sectionItem = sectionItem

        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension DetailHorizontalSectionController: SynopsisSectionControllerDelegate {
    /// 시놉시스 탭 시 글 전체가 보이도록 확장/축소
    func didTapSynopsisItem(at index: Int, isExpand: Bool) {
        self.isExpand = isExpand
        
        if let vc = viewController as? ContentsDetailViewController {
            vc.collectionView?.collectionViewLayout.invalidateLayout()

            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                vc.collectionView?.layoutIfNeeded()
            } completion: { (_) in
                self.cellAdapter.collectionView?.collectionViewLayout.invalidateLayout()
                self.cellAdapter.collectionView?.layoutIfNeeded()
            }
        }
    }
}
