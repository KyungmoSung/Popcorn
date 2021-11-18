//
//  SplashViewController.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/11/02.
//

import UIKit
import RxSwift
import NSObject_Rx

class SplashViewController: BaseViewController {
    var viewModel: SplashViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
                
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = SplashViewModel.Input(ready: rx.viewWillAppear.take(1).asObservable())
        let output = viewModel.transform(input: input)
        
        output.settingConfig
            .asDriverOnErrorJustComplete()
            .drive()
            .disposed(by: rx.disposeBag)
    }
}
