//
//  RecommendViewController.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/11/01.
//

import UIKit

class RecommendViewController: _BaseViewController {
    var viewModel: RecommendViewModel!
    
    convenience init(viewModel: RecommendViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }

    private func bindViewModel() {
        let input = RecommendViewModel.Input(ready: rx.viewWillAppear.asObservable())
        let output = viewModel.transform(input: input)
        
        output.needSignIn
            .asDriverOnErrorJustComplete()
            .drive()
            .disposed(by: disposeBag)
    }
}
