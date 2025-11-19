//
//  UIApplication+Extensions.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 18.11.2025.
//

import UIKit

extension UIApplication {
    var safeAreaTop: CGFloat {
        windows.first(where: { $0.isKeyWindow })?.safeAreaInsets.top ?? 0
    }

    var safeAreaInsets: UIEdgeInsets? {
        windows.first(where: { $0.isKeyWindow })?.safeAreaInsets
    }

    var isNotchDevice: Bool {
        safeAreaTop > 24
    }
}
