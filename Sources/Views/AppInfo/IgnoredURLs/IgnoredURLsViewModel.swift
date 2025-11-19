//
//  IgnoredURLsViewModel.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 12.11.2025.
//

// MARK: - ViewModel

import SwiftUI

final class IgnoredURLsViewModel: ObservableObject {
    @Published var ignoredURLs: [String] = HeliosTraceSettings.shared.ignoredURLs ?? []
    @Published var onlyURLs: [String] = HeliosTraceSettings.shared.onlyURLs ?? []
    @Published var ignoredPrefixLogs: [String] = HeliosTraceSettings.shared.ignoredPrefixLogs ?? []
    @Published var onlyPrefixLogs: [String] = HeliosTraceSettings.shared.onlyPrefixLogs ?? []

    var sections: [(title: String, items: [String])] {
        [
            ("Ignored URLs", ignoredURLs),
            ("Only URLs", onlyURLs),
            ("Ignored Prefix Logs", ignoredPrefixLogs),
            ("Only Prefix Logs", onlyPrefixLogs)
        ]
    }
}
