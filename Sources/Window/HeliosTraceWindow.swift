//
//  HeliosTraceWindow.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 11.11.2025.
//

import UIKit

protocol WindowDelegate: AnyObject {
    func isPointEvent(point: CGPoint) -> Bool
}

class HeliosTraceWindow: UIWindow {
    weak var delegate: WindowDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .clear
        self.isOpaque = false
        self.windowLevel = UIWindow.Level(rawValue: UIWindow.Level.alert.rawValue - 1)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return self.delegate?.isPointEvent(point: point) ?? false
    }
}

extension WindowHelper: WindowDelegate {
    func isPointEvent(point: CGPoint) -> Bool {
        // When the debug list (Tabbar) is displayed, allow interactions anywhere in this window.
        if displayedList {
            return true
        }
        // Otherwise, only allow touches on the floating bubble.
        if let bubbleView = bubbleView {
            let pointInBubble = bubbleView.convert(point, from: window)
            return bubbleView.bounds.contains(pointInBubble)
        }
        return false
    }
}
