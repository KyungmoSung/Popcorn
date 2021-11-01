//
//  SignViewController.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/11/01.
//

import UIKit
import RxSwift
import RxCocoa

class SignViewController: _BaseViewController {
    var viewModel: SignViewModel!
    
    @IBOutlet weak var signBtn: UIButton!
    
    convenience init(viewModel: SignViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hidesNavigationBar = true
        hidesTabBar = false
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = SignViewModel.Input(signTrigger: signBtn.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        
        output.signInSuccess
            .asDriverOnErrorJustComplete()
            .drive()
            .disposed(by: disposeBag)
    }
}
