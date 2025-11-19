//
//  OCLogStoreManager.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 10.11.2025.
//

import Foundation

final class OCLogStoreManager {
    static let shared = OCLogStoreManager()

    private(set) var normalLogs: [OCLogModel] = []
    private(set) var rnLogs: [OCLogModel] = []
    private(set) var webLogs: [OCLogModel] = []

    private let maxCount = 1000

    private init() {}

    // MARK: - Add Log

    func addLog(_ log: OCLogModel) {
        // 🔹 Sadece belirli prefix’leri içeren loglar
        for prefix in NetworkHelper.shared.onlyPrefixLogs ?? [] {
            if !log.content.lowercased().hasPrefix(prefix.lowercased()) {
                return
            }
        }

        // 🔹 Ignore edilmesi gereken prefix’leri atla
        for prefix in NetworkHelper.shared.ignoredPrefixLogs ?? [] {
            if log.content.lowercased().hasPrefix(prefix.lowercased()) {
                return
            }
        }

        // 🔹 Log’u uygun array’e ekle
        switch log.logType {
        case .normal:
            append(log, to: &normalLogs)

        case .rn:
            append(log, to: &rnLogs)

        case .web:
            append(log, to: &webLogs)
        }
    }

    // MARK: - Remove Log

    func removeLog(_ log: OCLogModel) {
        switch log.logType {
        case .normal:
            normalLogs.removeAll { $0 === log }

        case .rn:
            rnLogs.removeAll { $0 === log }

        case .web:
            webLogs.removeAll { $0 === log }
        }
    }

    // MARK: - Reset Methods

    func resetNormalLogs() {
        normalLogs.removeAll()
    }

    func resetRNLogs() {
        rnLogs.removeAll()
    }

    func resetWebLogs() {
        webLogs.removeAll()
    }

    // MARK: - Private Helpers

    private func append(_ log: OCLogModel, to array: inout [OCLogModel]) {
        if array.count >= maxCount {
            array.removeFirst()
        }
        array.append(log)
    }
}
