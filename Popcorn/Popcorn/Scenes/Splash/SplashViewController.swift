//
//  SplashViewController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/11/02.
//

import UIKit
import RxSwift
import NSObject_Rx

class SplashViewController: _BaseViewController {
    var viewModel: SplashViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
                
        bindViewModel()
    }
    
    func bindViewModel() {
        let output = viewModel.transform(input: SplashViewModel.Input(ready: rx.viewWillAppear.asDriver()))
        
        output.settingConfig
            .drive()
            .disposed(by: rx.disposeBag)
    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        Config.shared.fetch {
//            self.present(self.groundTabBarController, animated: true, completion: nil)
//        }
//    }
    
}
