//
//  _RxExtension.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/23.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewWillAppear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear(_:))).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewWillDisappear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillDisappear(_:))).map { _ in }
        return ControlEvent(events: source)
    }
}


extension ObservableType {
    func catchErrorJustComplete() -> Observable<Element> {
        return catchError { _ in
            return Observable.empty()
        }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            assertionFailure("Error \(error)")
            return Driver.empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}

extension ObservableType where Element: Content {
    func mapToContent() -> Observable<Content> {
        return map { $0 as Content}
    }
}

extension ObservableType where Element: Collection, Element.Element: Content {
    func mapToContents() -> Observable<[Content]> {
        return map { $0.map { $0 as Content }}
    }
}

extension ObservableType {
    func mapToContents<T>() -> Observable<[Content]> where Element == PageResponse<T>{
        return compactMap { $0.results as? [Content] }
    }
    
    func mapToResults<T>() -> Observable<[T]> where Element == PageResponse<T>{
        return compactMap { $0.results }
    }
}
