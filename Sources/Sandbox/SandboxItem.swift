//
//  SandboxItem.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 13.11.2025.
//

import Foundation

#if canImport(QuickLook)
    import QuickLook
#endif

struct SandboxItem: Identifiable, Hashable {
    let id: UUID
    let url: URL
    let displayName: String
    let attributes: [FileAttributeKey: Any]
    let type: SandboxFileType
    let modificationDateText: String
    let childCount: Int
    let sizeDescription: String
    let isDirectory: Bool

    init(url: URL, attributes: [FileAttributeKey: Any]) {
        self.id = UUID()
        self.url = url
        self.displayName = url.lastPathComponent
        self.attributes = attributes
        let isDirectory = (attributes[.type] as? FileAttributeType) == .typeDirectory
        self.isDirectory = isDirectory
        self.type = SandboxFileType(fileExtension: url.pathExtension, isDirectory: isDirectory)

        let helper = SandboxHelper.shared
        let modificationDate = attributes[.modificationDate] as? Date
        let modificationText = helper.formattedModificationDate(from: modificationDate)

        if isDirectory {
            self.childCount = SandboxItem.childItemCount(for: url)
            self.sizeDescription = helper.sizeOfDirectory(at: url.path)
        } else {
            self.childCount = 0
            self.sizeDescription = helper.sizeOfFile(at: url.path)
        }

        if modificationText.isEmpty {
            self.modificationDateText = sizeDescription
        } else if sizeDescription.isEmpty {
            self.modificationDateText = "[\(modificationText)]"
        } else {
            self.modificationDateText = "[\(modificationText)] \(sizeDescription)"
        }
    }

    static func childItemCount(for url: URL) -> Int {
        guard let contents = try? FileManager.default.contentsOfDirectory(atPath: url.path) else {
            return 0
        }
        let manager = SandboxManager.shared
        return contents.reduce(into: 0) { count, item in
            if manager.systemFilesHidden && item.hasPrefix(".") {
                return
            }
            count += 1
        }
    }

    var icon: ImageResource {
        if isDirectory && childCount == 0 {
            return .iconFileTypeFolderEmpty
        }
        return type.icon
    }

    var canPreviewInQuickLook: Bool {
        #if canImport(QuickLook)
            return QLPreviewController.canPreview(url as NSURL)
        #else
            return false
        #endif
    }

    var canPreviewInWebView: Bool {
        type.supportsWebPreview
    }

    static func == (lhs: SandboxItem, rhs: SandboxItem) -> Bool {
        lhs.url == rhs.url
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
}
