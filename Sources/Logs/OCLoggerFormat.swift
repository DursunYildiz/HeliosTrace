//
//  OCLoggerFormat.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 10.11.2025.
//

import Foundation
final class OCLoggerFormat {
    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
}
