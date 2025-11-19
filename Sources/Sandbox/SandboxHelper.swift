//
//  SandboxHelper.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 13.11.2025.
//

import Foundation

final class SandboxHelper {
    static let shared = SandboxHelper()

    private let sizeFormatter: ByteCountFormatter
    private let dateFormatter: DateFormatter
    private init() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        dateFormatter = formatter

        let byteFormatter = ByteCountFormatter()
        byteFormatter.allowedUnits = .useAll
        byteFormatter.countStyle = .file
        sizeFormatter = byteFormatter
    }

    // MARK: - Date

    func formattedModificationDate(from date: Date?) -> String {
        guard let date else { return "" }
        return dateFormatter.string(from: date)
    }

    // MARK: - Size

    func sizeOfFile(at path: String) -> String {
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: path),
              let fileSize = attributes[.size] as? NSNumber
        else {
            return "0 B"
        }

        return sizeFormatter.string(fromByteCount: fileSize.int64Value)
    }

    func sizeOfDirectory(at path: String) -> String {
        guard let enumerator = FileManager.default.enumerator(atPath: path) else {
            return "0 B"
        }

        var total: Int64 = 0
        for case let item as NSString in enumerator {
            let fullPath = (path as NSString).appendingPathComponent(item as String)
            if let attributes = try? FileManager.default.attributesOfItem(atPath: fullPath),
               let fileSize = attributes[.size] as? NSNumber
            {
                total += fileSize.int64Value
            }
        }

        return sizeFormatter.string(fromByteCount: total)
    }

    // MARK: - Search Persistence

    private var searchTextStorage = [String: String]()
    private let searchLock = NSLock()

    subscript(searchKey key: String) -> String? {
        get {
            searchLock.lock()
            defer { searchLock.unlock() }
            return searchTextStorage[key]
        }
        set {
            searchLock.lock()
            if let newValue {
                searchTextStorage[key] = newValue
            } else {
                searchTextStorage.removeValue(forKey: key)
            }
            searchLock.unlock()
        }
    }

    func generateRandomIdentifier() -> String {
        let time = UInt64(Date().timeIntervalSince1970 * 1000)
        let scalars = (0..<10).compactMap { _ in UnicodeScalar(65 + Int.random(in: 0..<26)) }
        let randomString = String(String.UnicodeScalarView(scalars))
        return "\(time)_\(randomString)"
    }
}
