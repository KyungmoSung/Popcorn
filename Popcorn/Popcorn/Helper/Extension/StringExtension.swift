//
//  StringExtension.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/11/02.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
