//
//  BaseViewController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/12/15.
//

import UIKit

class BaseViewController: UIViewController {
    var navigationBarIsHidden: Bool = true
    var tabBarIsHidden: Bool = false
    var transparentNavigationBarOffsetY: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        hero.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = navigationBarIsHidden
        tabBarController?.tabBar.isHidden = tabBarIsHidden
    }
    
    func setNavigation(title: String?, navigationBar: Bool = true, tabBar: Bool = false) {
        self.title = title
        navigationBarIsHidden = !navigationBar
        tabBarIsHidden = !tabBar
        
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
