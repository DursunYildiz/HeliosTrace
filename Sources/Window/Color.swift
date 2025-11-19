//
//  Color.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 11.11.2025.
//

import SwiftUI

extension Color {
    static var colorGradientHead: [CGColor] {
        return [UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.00).cgColor,
                UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.00).cgColor]
    }

    static var primaryColor: Color {
        if UITraitCollection.current.userInterfaceStyle == .dark {
            return .white
        } else {
            return .black
        }
    }
}
