//
//  NetworkDetailView.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 11.11.2025.
//

import SwiftUI

struct NetworkDetailView: View {
    let model: HttpModel
    let allModels: [HttpModel]

    @State private var showShareSheet = false
    @State private var shareContent: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(model.url?.absoluteString ?? "-")
                    .font(.headline)

                if let method = model.method {
                    DetailField(label: "Method",
                                value: method,
                                valueColor: model.methodColor)
                }

                if let code = model.statusCode {
                    DetailField(label: "Status",
                                value: code,
                                valueColor: model.statusColor)
                }

                if let requestHeader = model.requestHeaderFields {
                    DetailField(label: "Request Headers",
                                value: prettyPrintedString(from: requestHeader))
                }

                if let responseHeader = model.responseHeaderFields {
                    DetailField(label: "Response Headers",
                                value: prettyPrintedString(from: responseHeader))
                }

                if let requestBody = model.requestData?.dataToPrettyPrintString() {
                    DetailField(label: "Request Body",
                                value: requestBody)
                }

                DetailField(label: "Response Body",
                            value: model.responseData?.dataToPrettyPrintString() ?? "Sıfır KB")

                if let size = model.size {
                    DetailField(label: "Response Size", value: size)
                }

                if let totalDuration = model.totalDuration {
                    DetailField(label: "TOTAL TIME", value: totalDuration)
                }

                if let mimeType = model.mimeType {
                    DetailField(label: "MIME TYPE", value: mimeType)
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
        }

        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    copyAllInfoAndShare()
                } label: {
                    Label("Copy & Share", systemImage: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ActivityView(activityItems: [shareContent])
        }
    }

    // MARK: - Copy & Share

    private func copyAllInfoAndShare() {
        var combined = ""

        combined += "URL: \(model.url?.absoluteString ?? "-")\n"
        combined += "Method: \(model.method ?? "-")\n"
        combined += "Status: \(model.statusCode ?? "-")\n"
        if let requestHeader = model.requestHeaderFields {
            combined += "Request Headers:\n\(prettyPrintedString(from: requestHeader))\n"
        }
        if let responseHeader = model.responseHeaderFields {
            combined += "Response Headers:\n\(prettyPrintedString(from: responseHeader))\n"
        }
        if let requestBody = model.requestData?.dataToPrettyPrintString() {
            combined += "Request Body:\n\(requestBody)\n"
        }
        combined += "Response Body:\n\(model.responseData?.dataToPrettyPrintString() ?? "Sıfır KB")\n"
        combined += "Response Size: \(model.size ?? "-")\n"
        combined += "Total Time: \(model.totalDuration ?? "-")\n"
        combined += "MIME Type: \(model.mimeType ?? "-")"

        #if canImport(UIKit)
            UIPasteboard.general.string = combined
        #endif

        shareContent = combined
        showShareSheet = true
    }
}

// MARK: - UIKit ActivityViewController Bridge

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems,
                                 applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// Dikey (alt alta) detay alanı
private struct DetailField: View {
    let label: String
    let value: String
    var valueColor: Color = .primaryColor

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.subheadline)
                .adaptiveForegroundStyle(.secondary)

            Text(value)
                .font(.footnote)
                .adaptiveForegroundStyle(valueColor)
        }
        .contextMenu {
            Button {
                copyToPasteboard(value)
            } label: {
                Label("Copy Value", systemImage: "doc.on.doc")
            }
            Button {
                copyToPasteboard("\(label): \(value)")
            } label: {
                Label("Copy Field", systemImage: "clipboard")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func copyToPasteboard(_ text: String) {
        #if canImport(UIKit)
            UIPasteboard.general.string = text
        #endif
    }
}

// MARK: - Preview

struct NetworkDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let mockModel = HttpModel(
            url: URL(string: "https://api.example.com/v1/users"),
            requestData: "{\"username\": \"test\"}".data(using: .utf8),
            responseData: "{\"id\": 1, \"name\": \"Test User\"}".data(using: .utf8),
            requestId: "12345",
            method: "POST",
            statusCode: "200",
            mimeType: "application/json",
            startTime: "0 ms",
            endTime: "150 ms",
            totalDuration: "150 ms",
            requestHeaderFields: ["Content-Type": "application/json"],
            responseHeaderFields: ["Content-Type": "application/json", "Date": "Tue, 11 Nov 2025 10:00:00 GMT"],
            size: "1.2 KB"
        )

        NavigationView {
            NetworkDetailView(model: mockModel, allModels: [mockModel])
        }
    }
}
