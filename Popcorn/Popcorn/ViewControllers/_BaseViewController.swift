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
    var disposeBag = DisposeBag()
    
    var languageChanged = PublishRelay<Void>()
    var regionChanged = PublishRelay<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotification()
    }
    
    private func setupNotification() {
        NotificationCenter.default.rx.notification(.languageChanged)
            .subscribe(onNext: { _ in
                self.languageChanged.accept(())
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.regionChanged)
            .subscribe(onNext: { _ in
                self.regionChanged.accept(())
            })
            .disposed(by: disposeBag)
    }
}
