//
//  VIewModelType.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/08/19.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
