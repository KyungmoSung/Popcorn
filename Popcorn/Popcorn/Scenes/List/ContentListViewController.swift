//
//  ContentListViewController.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/09/10.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ContentListViewController: BaseViewController {
    var viewModel: BaseViewModel!
    let selectedSegmentIndex = PublishRelay<Int>()
    var showSortOptions = PublishRelay<Void>()
    let selectedSort = BehaviorRelay<Sort?>(value: nil)

    @IBOutlet weak var collectionView: UICollectionView!
    
    convenience init(viewModel: BaseViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        collectionView.register(cellType: PosterCell.self)
        collectionView.register(cellType: CreditCell.self)
        collectionView.register(reusableViewType: ListFilterHeaderView.self)
    }

    private func bindViewModel() {
        let ready = rx.viewWillAppear.take(1).asObservable()
        let scrollToBottom = collectionView.rx.contentOffset
            .flatMap { offset -> Observable<Void> in
                let scrollViewHeight = self.collectionView.bounds.size.height
                let contentHeight = self.collectionView.contentSize.height

                let itemCount = self.collectionView.numberOfItems(inSection: 0)
                if itemCount > 0,
                    contentHeight > scrollViewHeight,
                    offset.y + scrollViewHeight > contentHeight {
                    return Observable.just(())
                } else {
                    return Observable.empty()
                }
            }.throttle(.seconds(1), scheduler: MainScheduler.instance)
        
        switch viewModel {
        case let viewModel as ContentListViewModel:
            let input = ContentListViewModel.Input(ready: ready,
                                                   scrollToBottom: scrollToBottom,
                                                   selection: collectionView.rx.itemSelected.asObservable(),
                                                   segmentSelection: selectedSegmentIndex
                                                    .startWith(0)
                                                    .asObservable(),
                                                   sortSelection: selectedSort.asObservable())
            let output = viewModel.transform(input: input)
            
            output.title
                .asDriverOnErrorJustComplete()
                .drive(rx.title)
                .disposed(by: disposeBag)
            
            output.sectionItems
                .asDriverOnErrorJustComplete()
                .drive(collectionView.rx.items(dataSource: contentsDataSource()))
                .disposed(by: disposeBag)
            
            output.selectedContent
                .asDriverOnErrorJustComplete()
                .drive()
                .disposed(by: disposeBag)
            
            // 세그먼트 표시 여부 변경시 컬렉션뷰 레이아웃 세팅
            output.segmentedControlVisible
                .asDriverOnErrorJustComplete()
                .map(createCompositionalLayout(with:))
                .drive(onNext: { [weak self] layout in
                    guard let self = self else { return }
                    self.collectionView.collectionViewLayout = layout
                })
                .disposed(by: disposeBag)

            // 정렬옵션이 변경되면 선택되어있던 옵션 제거
            output.sorts
                .asDriverOnErrorJustComplete()
                .drive(onNext: { _ in
                    self.selectedSort.accept(nil)
                })
                .disposed(by: disposeBag)
            
            // 정렬옵션 버튼 선택시 Alert 호출
            showSortOptions.withLatestFrom(output.sorts)
                .asDriverOnErrorJustComplete()
                .compactMap{ $0 }
                .drive(onNext: { sorts in
                    let alert = UIAlertController(title: "Sort by",
                                                  message: nil,
                                                  preferredStyle: .actionSheet)
                    
                    for sort in sorts {
                        let sortAction = UIAlertAction(title: sort.title, style: .default, handler: { _ in
                            self.selectedSort.accept(sort)
                        })
                        alert.addAction(sortAction)
                    }
                    
                    let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alert.addAction(noAction)
                    
                    self.present(alert, animated: true, completion: nil)
                })
                .disposed(by: disposeBag)
                
        case let viewModel as CreditListViewModel:
            let input = CreditListViewModel.Input(ready: ready)
            let output = viewModel.transform(input: input)
            
            output.title
                .asDriverOnErrorJustComplete()
                .drive(rx.title)
                .disposed(by: disposeBag)
            
            output.sectionItems
                .asDriverOnErrorJustComplete()
                .drive(collectionView.rx.items(dataSource: creditsDataSource()))
                .disposed(by: disposeBag)
        default:
            break
        }
    }
}

extension ContentListViewController {
    typealias ContentsDataSource = RxCollectionViewSectionedAnimatedDataSource<ContentListViewModel.ListSectionItem>
    typealias CreditsDataSource = RxCollectionViewSectionedAnimatedDataSource<CreditListViewModel.ListSectionItem>
    
    private func contentsDataSource() -> ContentsDataSource {
        return ContentsDataSource { dataSource, collectionView, indexPath, viewModel in
            let cell = collectionView.dequeueReusableCell(with: PosterCell.self, for: indexPath)
            cell.bind(viewModel)
            
            return cell
        } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
            let headerView = collectionView.dequeueReusableView(with: ListFilterHeaderView.self, for: indexPath, ofKind: kind)
            
            let section = indexPath.section
            let sectionModel = dataSource.sectionModels[section]
            
            sectionModel.section.segmentTitles?.enumerated().forEach{ index, title in
                Observable.just(title)
                    .bind(to: headerView.segmentedControl.rx.titleForSegment(at: index))
                    .disposed(by: headerView.disposeBag)
            }
            
            headerView.segmentedControl.rx.value
                .bind(to: self.selectedSegmentIndex)
                .disposed(by: headerView.disposeBag)
            
            headerView.sortBtn.rx.tap
                .bind(to: self.showSortOptions)
                .disposed(by: headerView.disposeBag)            
            
            self.selectedSort
                .map{ $0?.title ?? "Sort" }
                .bind(to: headerView.sortBtn.rx.title())
                .disposed(by: headerView.disposeBag)
            
            return headerView
        }
    }
    
    private func creditsDataSource() -> CreditsDataSource {
        return CreditsDataSource { dataSource, collectionView, indexPath, viewModel in
            let cell = collectionView.dequeueReusableCell(with: CreditCell.self, for: indexPath)
            cell.bind(viewModel)
            
            return cell
        }
    }

    private func createCompositionalLayout(with headerVisible: Bool) -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout {   sectionIndex, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .estimated(100))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .estimated(100))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
            group.interItemSpacing = .fixed(15)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 30
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 40, trailing: 20)
            
            // Header
            if headerVisible {
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .estimated(100))
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                                elementKind: UICollectionView.elementKindSectionHeader,
                                                                                alignment: .top)
                sectionHeader.pinToVisibleBounds = true
                section.boundarySupplementaryItems = [sectionHeader]
            }
            return section
        }
    }
}
