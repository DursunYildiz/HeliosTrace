//
//  HttpModel.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 10.11.2025.
//

import Foundation
import SwiftUI
import UIKit

public enum RequestSerializer: UInt {
    case json = 0 // JSON format
    case form // Form format
}

public final class HttpModel {
    // MARK: - Basic info

    public var url: URL?
    public var requestData: Data?
    public var responseData: Data?
    public var requestId: String?
    public var method: String?
    public var statusCode: String?
    public var mimeType: String?
    public var startTime: String?
    public var endTime: String?
    public var totalDuration: String?
    public var isImage: Bool = false

    // MARK: - Headers

    public var requestHeaderFields: [String: Any]?
    public var responseHeaderFields: [String: Any]?

    // MARK: - Flags

    var isTag: Bool = false
    var isSelected: Bool = false

    // MARK: - Serializer & Errors

    var requestSerializer: RequestSerializer = .json
    var errorDescription: String?
    var errorLocalizedDescription: String?

    // MARK: - Size

    public var size: String?

    // MARK: - Init

    public init(url: URL? = nil,
                requestData: Data? = nil,
                responseData: Data? = nil,
                requestId: String? = nil,
                method: String? = nil,
                statusCode: String? = nil,
                mimeType: String? = nil,
                startTime: String? = nil,
                endTime: String? = nil,
                totalDuration: String? = nil,
                isImage: Bool = false,
                requestHeaderFields: [String: Any]? = nil,
                responseHeaderFields: [String: Any]? = nil,
                isTag: Bool = false,
                isSelected: Bool = false,
                requestSerializer: RequestSerializer = .json,
                errorDescription: String? = nil,
                errorLocalizedDescription: String? = nil,
                size: String? = nil)
    {
        self.url = url
        self.requestData = requestData
        self.responseData = responseData
        self.requestId = requestId
        self.method = method
        self.statusCode = statusCode
        self.mimeType = mimeType
        self.startTime = startTime
        self.endTime = endTime
        self.totalDuration = totalDuration
        self.isImage = isImage
        self.requestHeaderFields = requestHeaderFields
        self.responseHeaderFields = responseHeaderFields
        self.isTag = isTag
        self.isSelected = isSelected
        self.requestSerializer = requestSerializer
        self.errorDescription = errorDescription
        self.errorLocalizedDescription = errorLocalizedDescription
        self.size = size
    }

    // MARK: - Computed Properties

    var methodColor: Color {
        switch method?.uppercased() {
        case "GET": return .green
        case "POST": return .blue
        case "PUT": return .orange
        case "DELETE": return .red
        default: return .gray
        }
    }

    var statusColor: Color {
        guard let statusInt = Int(statusCode ?? "") else { return .gray }
        switch statusInt {
        case 200..<300: return .green
        case 300..<400: return .orange
        case 400..<500: return .red
        case 500..<600: return .purple
        default: return .gray
        }
    }
}
