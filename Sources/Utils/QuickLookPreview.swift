//
//  QuickLookPreview.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 19.11.2025.
//

import QuickLook
import SwiftUI

struct QuickLookPreview: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return controller
    }

    func updateUIViewController(_ controller: QLPreviewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(url: url)
    }

    class Coordinator: NSObject, QLPreviewControllerDataSource {
        let url: URL
        init(url: URL) { self.url = url }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int { 1 }

        func previewController(_ controller: QLPreviewController,
                               previewItemAt index: Int) -> QLPreviewItem
        {
            url as NSURL
        }
    }
}

struct FilePreviewItem: Identifiable {
    let id = UUID()
    let url: URL
}
