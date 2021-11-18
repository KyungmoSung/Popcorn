//
//  FloatingLayout.swift
//  Popcorn
//
//  Created by Front-Artist on 2021/02/04.
//

import Foundation
import FloatingPanel

class FloatingLayout: FloatingPanelLayout {
    var position: FloatingPanelPosition = .bottom
    var initialState: FloatingPanelState = .half
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 10.0, edge: .top, referenceGuide: .safeArea),
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.3, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
}
