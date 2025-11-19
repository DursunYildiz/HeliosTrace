//
//  SandboxManager.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 13.11.2025.
//

import Foundation

final class SandboxManager {
    static let shared = SandboxManager()

    // MARK: - Configuration

    var systemFilesHidden: Bool {
        didSet { invalidateCaches() }
    }

    var homeURL: URL {
        didSet { invalidateCaches() }
    }

    var homeTitle: String

    var extensionHidden: Bool
    var isShareable: Bool
    var isFileDeletable: Bool
    var isDirectoryDeletable: Bool

    private let fileManager: FileManager
    private let cacheQueue = DispatchQueue(label: "io.cocoadbug.sandbox.cache", qos: .userInitiated)
    private var directoryCache: [URL: [SandboxItem]] = [:]

    private init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        self.systemFilesHidden = true
        self.extensionHidden = false
        self.isShareable = true
        self.isFileDeletable = false
        self.isDirectoryDeletable = false
        self.homeURL = URL(fileURLWithPath: NSHomeDirectory(), isDirectory: true)
        self.homeTitle = "Sandbox"
    }

    // MARK: - Loading

    func contents(of url: URL) -> [SandboxItem] {
        cacheQueue.sync {
            if let cached = directoryCache[url] {
                return cached
            }
            let items = readContents(of: url)
            directoryCache[url] = items
            return items
        }
    }

    func refreshContents(of url: URL) -> [SandboxItem] {
        cacheQueue.sync {
            let items = readContents(of: url)
            directoryCache[url] = items
            return items
        }
    }

    func delete(_ item: SandboxItem) throws {
        if item.isDirectory, !isDirectoryDeletable {
            throw SandboxManagerError.deletionNotAllowed
        }
        if !item.isDirectory, !isFileDeletable {
            throw SandboxManagerError.deletionNotAllowed
        }
        try fileManager.removeItem(at: item.url)
        invalidateCaches()
    }

    func rename(_ item: SandboxItem, to newName: String) throws {
        let sanitized = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !sanitized.isEmpty else {
            throw SandboxManagerError.invalidFileName
        }

        let destination = item.url.deletingLastPathComponent().appendingPathComponent(sanitized)
        try fileManager.moveItem(at: item.url, to: destination)
        invalidateCaches()
    }

    // MARK: - Helpers

    private func readContents(of url: URL) -> [SandboxItem] {
        let options: FileManager.DirectoryEnumerationOptions = systemFilesHidden ? [.skipsPackageDescendants, .skipsHiddenFiles] : [.skipsPackageDescendants]

        guard let contents = try? fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: [.isDirectoryKey, .contentModificationDateKey, .fileSizeKey], options: options) else {
            return []
        }

        let items = contents.compactMap { url -> SandboxItem? in
            let path = url.path
            guard let attributes = try? fileManager.attributesOfItem(atPath: path) else {
                return nil
            }
            return SandboxItem(url: url, attributes: attributes)
        }

        return items.sorted(by: { lhs, rhs in
            switch (lhs.isDirectory, rhs.isDirectory) {
            case (true, false): return true
            case (false, true): return false
            default:
                return lhs.displayName.localizedCaseInsensitiveCompare(rhs.displayName) == .orderedAscending
            }
        })
    }

    private func invalidateCaches() {
        cacheQueue.async(flags: .barrier) {
            self.directoryCache.removeAll()
        }
    }
}

enum SandboxManagerError: LocalizedError {
    case deletionNotAllowed
    case invalidFileName

    var errorDescription: String? {
        switch self {
        case .deletionNotAllowed:
            return "Deletion is not permitted for this item."
        case .invalidFileName:
            return "The provided name is invalid."
        }
    }
}
