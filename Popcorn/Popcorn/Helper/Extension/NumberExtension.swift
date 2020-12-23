//
//  NumberExtension.swift
//  Popcorn
//
//  Created by Kyungmo on 2020/12/24.
//

import Foundation

extension Int {
    func asCurrencyFormat() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "en_US")
        numberFormatter.minimumFractionDigits = 0
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}
