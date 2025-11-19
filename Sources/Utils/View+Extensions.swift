//
//  View+Extensions.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 12.11.2025.
//

import SwiftUI

extension View {
    /// Uses `.foregroundStyle` on iOS 15+, `.foregroundColor` otherwise.
    @ViewBuilder
    func adaptiveForegroundStyle(_ color: Color) -> some View {
        if #available(iOS 15, *) {
            self.foregroundStyle(color)
        } else {
            foregroundColor(color)
        }
    }
}


