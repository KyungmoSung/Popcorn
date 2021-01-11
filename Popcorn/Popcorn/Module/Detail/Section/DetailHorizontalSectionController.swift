//
//  HorizontalSectionController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import UIKit

class DetailHorizontalSectionController: ListSectionController {

    private var sectionItem: DetailSectionItem?
    var selectedSubSection: Int = 0 {
        didSet {
            cellAdapter.performUpdates(animated: true, completion: nil)
        }
    }
    
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
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, let detailSection = sectionItem?.detailSection else {
            return .zero
        }
        
        switch detailSection {
        case .synopsis:
            if let items = sectionItem?.items as? [String], items.count > 0 {
                // 텍스트 높이 계산
                let totalHeight = items
                    .enumerated()
                    .map{ $0.element.height(for: .NanumSquare(size: 14, family: (items.count >= 2) ? (($0.offset == 0) ? .Bold : .Regular) : .Regular), width: context.containerSize.width - 60) }
                    .reduce(0) { $0 + $1 }
                return CGSize(width: context.containerSize.width, height: totalHeight)
            }
        default:
            break
        }
        
        return CGSize(width: context.containerSize.width, height: detailSection.height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let context = collectionContext, let detailSection = sectionItem?.detailSection else {
            return UICollectionViewCell()
        }
        
        let cell: EmbeddedCollectionViewCell = context.dequeueReusableXibCell(for: self, at: index)
        cellAdapter.collectionView = cell.collectionView
        
        switch detailSection {
        case .title, .detail: // 가로 스크롤 & 자동 넓이
            let layout = PagingCollectionViewLayout()
            layout.scrollDirection = .horizontal
            cell.collectionView.collectionViewLayout = layout
            cell.collectionView.isScrollEnabled = true
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        case .synopsis: // 세로 스크롤 & 자동 높이
            let layout = PagingCollectionViewLayout()
            layout.scrollDirection = .vertical
            cell.collectionView.collectionViewLayout = layout
            cell.collectionView.isScrollEnabled = false
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        default: // 세로 스크롤
            let layout = PagingCollectionViewLayout()
            layout.scrollDirection = .horizontal
            cell.collectionView.collectionViewLayout = layout
            cell.collectionView.isScrollEnabled = true
        }
        
        cell.collectionView.collectionViewLayout.invalidateLayout()
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        sectionItem = object as? DetailSectionItem
    }
}

extension DetailHorizontalSectionController: ListSupplementaryViewSource {
    func supportedElementKinds() -> [String] {
        return [UICollectionView.elementKindSectionHeader]
    }
    
    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        guard let context = collectionContext, let detailSection = sectionItem?.detailSection else {
            return .zero
        }
        
        switch detailSection {
        case .title(_, _, _):
            return CGSize(width: context.containerSize.width, height: 120)
        case .image(_):
            return CGSize(width: context.containerSize.width, height: 110)
        default:
            return CGSize(width: context.containerSize.width, height: 72)
        }
    }
    
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        guard let context = collectionContext, let detailSection = sectionItem?.detailSection else { return UICollectionReusableView() }
        switch detailSection {
        case .title(let title, let subTitle, let voteAverage):
            let headerView: ContentsHeaderVIew = context.dequeueReusableSupplementaryXibView(ofKind: UICollectionView.elementKindSectionHeader, for: self, at: index)
            
            headerView.title = title
            headerView.subTitle = subTitle
            headerView.voteAverage = voteAverage
            
            return headerView
        case .image(_):
            let headerView: SectionHeaderView = context.dequeueReusableSupplementaryXibView(ofKind: UICollectionView.elementKindSectionHeader, for: self, at: index)
            
            headerView.title = sectionItem?.detailSection.sectionTitle
            
            headerAdapter.collectionView?.isHidden = false
            headerAdapter.collectionView = headerView.tabCollectionView
            
            return headerView
        default:
            let headerView: SectionHeaderView = context.dequeueReusableSupplementaryXibView(ofKind: UICollectionView.elementKindSectionHeader, for: self, at: index)
            
            headerView.title = sectionItem?.detailSection.sectionTitle
            
            headerAdapter.collectionView?.isHidden = true
            headerAdapter.collectionView = nil
            
            return headerView
        }
    }
}

extension DetailHorizontalSectionController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard let detailSection = sectionItem?.detailSection else {
            return []
        }
        
        if listAdapter == cellAdapter {
            switch detailSection {
            case .image: // 선택된 이미지타입만 필터링 (포스터/배경)
                if let items = sectionItem?.items as? [ImageInfo] {
                    return items.filter{ return $0.type == ImageType(rawValue: selectedSubSection) }
                } else {
                    return []
                }
            default:
                return sectionItem?.items ?? []
            }
        } else {
            switch detailSection {
            case .image(let tabs):
                return tabs as [ListDiffable]
            default:
                return []
            }
        }
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        guard let detailSection = sectionItem?.detailSection else {
            return ListSectionController()
        }
        
        if listAdapter == cellAdapter {
            switch detailSection {
            case .title:
                let section = TextTagSectionController()
                if let contentsDetailVC = viewController as? ContentsDetailViewController {
                    section.delegate = contentsDetailVC
                }
                return section
            case .detail:
                return InfoCardSectionController()
            case .synopsis:
                return SynopsisSectionController()
            case .image:
                return MediaSectionController()
            case .video:
                return MediaSectionController()
            case .credit:
                return CreditSectionController()
            case .recommendation:
                return PosterSectionController(type: .poster)
            case .similar:
                return PosterSectionController(type: .poster)
            case .review:
                return ReviewSectionController()
            }
        } else {
            let section = TextTabSectionController()
            section.delegate = self
            return section
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension DetailHorizontalSectionController: TextTabDelegate {
    func didSelectTab(index: Int) {
        selectedSubSection = index
    }
}
