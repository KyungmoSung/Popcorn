//
//  HorizontalSectionController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/30.
//

import UIKit

class DetailHorizontalSectionController: ListSectionController {
    
    private var sectionItem: DetailSectionItem?
    var isExpand: Bool = false
    
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
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, let sectionItem = sectionItem else {
            return .zero
        }
        
        switch sectionItem.sectionType {
        case .synopsis:
            if let items = sectionItem.items as? [String], items.count > 0 {
                // 텍스트 높이 계산
                let totalHeight: CGFloat = items
                    .enumerated()
                    .map {
                        let text = isExpand ? $0.element.replacingOccurrences(of: ". ", with: ".\n\n") : $0.element
                        let numberOfLines = isExpand ? 0 : 5
                        let font = UIFont.NanumSquare(size: 14, family: .Regular)
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
        guard let context = collectionContext, let sectionItem = sectionItem else {
            return UICollectionViewCell()
        }
        
        let cell: EmbeddedCollectionViewCell = context.dequeueReusableCell(for: self, at: index)
        cellAdapter.collectionView = cell.collectionView
        
        if let layout = cell.collectionView.collectionViewLayout as? PagingCollectionViewLayout {
            switch sectionItem.sectionType {
            case .detail: // 가로 스크롤 & 자동 넓이
                layout.scrollDirection = .horizontal
                cell.collectionView.isScrollEnabled = true
                layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            case .synopsis: // 세로 스크롤 & 자동 높이
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
        sectionItem = object as? DetailSectionItem
    }
}

extension DetailHorizontalSectionController: ListSupplementaryViewSource {
    func supportedElementKinds() -> [String] {
        return [UICollectionView.elementKindSectionHeader]
    }
    
    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        guard let context = collectionContext, let sectionItem = sectionItem else {
            return .zero
        }
        
        switch sectionItem.sectionType {
        case .title(let title, _, _, _):
            let titleHeight = title.height(for: .NanumSquare(size: 30, family: .ExtraBold), lineSpacing: 0, numberOfLines: 0, width: context.containerSize.width - 132)
            return CGSize(width: context.containerSize.width, height: 223 + ceil(titleHeight))
        case .image(_):
            return CGSize(width: context.containerSize.width, height: 121)
        default:
            return CGSize(width: context.containerSize.width, height: 85)
        }
    }
    
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        guard let context = collectionContext, let sectionItem = sectionItem else {
            return UICollectionReusableView()
        }
        
        switch sectionItem.sectionType {
        case .title(let title, let subTitle, let voteAverage, _):
            let headerView: ContentsHeaderVIew = context.dequeueReusableSupplementaryXibView(ofKind: UICollectionView.elementKindSectionHeader, for: self, at: index)
            
            headerView.title = title
            headerView.subTitle = subTitle
            headerView.voteAverage = voteAverage
            headerAdapter.collectionView = headerView.genreCollectionView

            return headerView
        case .image(_):
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
            if sectionItem.sectionType == .synopsis || sectionItem.sectionType == .detail {
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
        guard let sectionItem = sectionItem else {
            return []
        }
        
        if listAdapter == cellAdapter {
            switch sectionItem.sectionType {
            case .image: // 선택된 이미지타입만 필터링 (포스터/배경)
                if let items = sectionItem.items as? [ImageInfo] {
                    let filterItem = items.filter{ return $0.type == ImageType(rawValue: selectedSubSection) }
                    return [DetailSectionItem(sectionItem.sectionType, items: filterItem)]
                }
            default:
                return [sectionItem]
            }
        } else {
            switch sectionItem.sectionType {
            case .title(_, _ , _, let genres):
                let tags = genres.map { Tag(id: $0.id, name: $0.name, isLoading: $0.isLoading) }
                return tags as [ListDiffable]
            case .image(let tabs):
                return tabs as [ListDiffable]
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
            case .detail:
                return InfoCardSectionController()
            case .synopsis:
                return SynopsisSectionController(delegate: self)
            case .image, .video:
                return MediaSectionController(direction: .horizontal)
            case .credit:
                return CreditSectionController(direction: .horizontal)
            case .recommendation, .similar:
                return PosterSectionController(type: .poster, direction: .horizontal)
            case .review:
                return ReviewSectionController(direction: .horizontal)
            default:
                break
            }
        } else {
            switch sectionItem.sectionType {
            case .title:
                return TextTagSectionController(delegate: self)
            case .image:
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
        selectedSubSection = index
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
        guard let sectionItem = sectionItem, let type = Section.Detail(rawValue: index) else {
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
