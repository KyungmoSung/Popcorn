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
    
    private func bindViewModel() {
        let input = SplashViewModel.Input(ready: rx.viewWillAppear.asDriver())
        let output = viewModel.transform(input: input)
        
        output.settingConfig
            .drive()
            .disposed(by: rx.disposeBag)
    }
}
