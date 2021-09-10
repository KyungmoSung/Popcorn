//
//  _BaseViewController.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/26.
//

import UIKit
import RxSwift
import RxCocoa

class _BaseViewController: UIViewController {
    var hidesNavigationBar: Bool = false
    var hidesTabBar: Bool = true
    var disposeBag = DisposeBag()
    
    var localizeChanged = PublishRelay<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hero.isEnabled = true

        setupNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = hidesNavigationBar
        tabBarController?.tabBar.isHidden = hidesTabBar
        
        setupNavigationBar()
    }
    
    private func setupNotification() {
        NotificationCenter.default.rx.notification(.languageChanged)
            .subscribe(onNext: { _ in
                self.localizeChanged.accept(())
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.regionChanged)
            .subscribe(onNext: { _ in
                self.localizeChanged.accept(())
            })
            .disposed(by: disposeBag)
    }
    
    func setupNavigationBar() {
        // 기본 뒤로가기 버튼 제거
        navigationItem.setHidesBackButton(true, animated: false);
        
        // 좌측 버튼 아이템 추가
        let leftBarBtnItemView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        
        let leftBtn = UIButton(type: .custom)
        leftBarBtnItemView.addSubview(leftBtn)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftBtn.setImage(UIImage(named: "icBack"), for: .normal)
        leftBtn.addTarget(self, action: #selector(didTapNavigationBackBtn), for: .touchUpInside)
        leftBtn.tintColor = .label
        
        let leftBarButtonItem = UIBarButtonItem(customView: leftBarBtnItemView)
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rightBarBtnItemView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        
        let rightBtn = UIButton(type: .custom)
        rightBarBtnItemView.addSubview(rightBtn)
        rightBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30) // 간격 20으로 맞추기 위해 x축으로 10 이동
        rightBtn.setImage(UIImage(named: "icSearch"), for: .normal)
        rightBtn.addTarget(self, action: #selector(didTapNavigationSearchBtn), for: .touchUpInside)
        rightBtn.tintColor = .label
        
        let rightBarButtonItem = UIBarButtonItem(customView: rightBarBtnItemView)
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func didTapNavigationBackBtn() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapNavigationSearchBtn() {
        
    }
}
