//
//  NavigationStackWrapper.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 12.11.2025.
//

import SwiftUI

struct NavigationStackWrapper<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                content
            }
        } else {
            NavigationView {
                content
            }
        }
    }
}
