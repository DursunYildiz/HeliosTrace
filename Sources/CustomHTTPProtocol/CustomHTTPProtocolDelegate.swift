//
//  CustomHTTPProtocolDelegate.swift
//  HeliosTrace-master
//
//  Created by Dursun  Yıldız on 10.11.2025.
//

import Foundation

protocol CustomHTTPProtocolDelegate: AnyObject {
    func customHTTPProtocol(
        _ protocol: CustomHTTPProtocol, didReceive challenge: URLAuthenticationChallenge
    )
    func customHTTPProtocol(
        _ protocol: CustomHTTPProtocol, didCancel challenge: URLAuthenticationChallenge
    )
    func customHTTPProtocol(
        _ protocol: CustomHTTPProtocol, canAuthenticateAgainst protectionSpace: URLProtectionSpace
    ) -> Bool
}

final class CustomHTTPProtocol: URLProtocol, URLSessionDataDelegate {
    private static let recursiveFlagKey = "com.apple.dts.CustomHTTPProtocol"
    private weak static var delegateInstance: CustomHTTPProtocolDelegate?

    var sessionTask: URLSessionDataTask?
    private var responseData = Data()
    private var startTime: TimeInterval = 0
    private var response: URLResponse?
    private var error: Error?

    // MARK: - Registration

    class func start() {
        URLProtocol.registerClass(Self.self)
    }

    class func stop() {
        URLProtocol.unregisterClass(Self.self)
    }

    class var delegate: CustomHTTPProtocolDelegate? {
        get { delegateInstance }
        set { delegateInstance = newValue }
    }

    // MARK: - Request Matching

    override class func canInit(with request: URLRequest) -> Bool {
        guard let scheme = request.url?.scheme?.lowercased(),
              scheme == "http" || scheme == "https"
        else {
            return false
        }
        if URLProtocol.property(forKey: recursiveFlagKey, in: request) != nil {
            return false
        }
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return CanonicalRequest.canonicalRequest(for: request)
    }

    // MARK: - Request Lifecycle

    override func startLoading() {
        guard let newRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {
            return
        }
        URLProtocol.setProperty(true, forKey: Self.recursiveFlagKey, in: newRequest)

        startTime = Date().timeIntervalSince1970
        responseData = Data()

        let config = URLSessionConfiguration.default
        config.protocolClasses = [type(of: self)]
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)

        sessionTask = session.dataTask(with: newRequest as URLRequest)
        sessionTask?.resume()
    }

    override func stopLoading() {
        sessionTask?.cancel()
        sessionTask = nil
        logRequestIfNeeded()
        // 🔔 Notification gönder
        NotificationCenter.default.post(
            name: .reloadHttpHeliosTrace,
            object: nil,
            userInfo: ["statusCode": "200"]
        )
    }

    // MARK: - Logging

    private func logRequestIfNeeded() {
        guard let url = request.url else { return }

        // Basics
        let methodString = request.httpMethod ?? "GET"
        print("📡 [HTTP] \(methodString) \(url.absoluteString)")

        // Timing
        let endTimestamp = Date().timeIntervalSince1970
        let durationMs = (endTimestamp - startTime) * 1000.0
        let startTimeString = String(format: "%.0f ms", 0.0)
        let endTimeString = String(format: "%.0f ms", durationMs)
        let totalDurationString = String(format: "%.0f ms", durationMs)

        // Response & headers
        let httpResponse = response as? HTTPURLResponse
        let statusCodeString =
            httpResponse.map { String($0.statusCode) } ?? (error == nil ? "200" : nil)
        let responseHeadersAny: [String: Any]? = httpResponse?.allHeaderFields.reduce(
            into: [String: Any]()
        ) { acc, pair in
            if let key = pair.key as? String {
                acc[key] = pair.value
            } else {
                acc["\(pair.key)"] = pair.value
            }
        }
        let requestHeadersAny: [String: Any]? = request.allHTTPHeaderFields?.reduce(
            into: [String: Any]()
        ) { acc, pair in
            acc[pair.key] = pair.value
        }

        // MIME type / image detection
        let mimeTypeString = response?.mimeType
        let isImage =
            (mimeTypeString?.lowercased().hasPrefix("image/") == true)
                || ["png", "jpg", "jpeg", "gif", "webp", "bmp", "tiff", "heic"]
                .contains(url.pathExtension.lowercased())

        // Serializer guess from Content-Type
        let contentType =
            (request.allHTTPHeaderFields?["Content-Type"] ?? request.allHTTPHeaderFields?["content-type"])?
                .lowercased()
        let serializer: RequestSerializer =
            (contentType?.contains("application/x-www-form-urlencoded") == true) ? .form : .json

        // Size (human readable)
        let bytesCount = responseData.count
        let sizeString: String = {
            if bytesCount < 1024 { return "\(bytesCount) B" }
            let kb = Double(bytesCount) / 1024.0
            if kb < 1024.0 { return String(format: "%.2f KB", kb) }
            let mb = kb / 1024.0
            return String(format: "%.2f MB", mb)
        }()

        print("✅ Response size: \(bytesCount) bytes")
        if let error = error {
            print("❌ Error: \(error.localizedDescription)")
        }

        // Build model
        let model = HttpModel(
            url: url,
            requestData: request.httpBody,
            responseData: responseData,
            requestId: UUID().uuidString,
            method: methodString,
            statusCode: statusCodeString,
            mimeType: mimeTypeString,
            startTime: startTimeString,
            endTime: endTimeString,
            totalDuration: totalDurationString,
            isImage: isImage,
            requestHeaderFields: requestHeadersAny,
            responseHeaderFields: responseHeadersAny,
            isTag: false,
            isSelected: false,
            requestSerializer: serializer,
            errorDescription: (error as NSError?)?.domain,
            errorLocalizedDescription: error?.localizedDescription,
            size: sizeString
        )

        _ = HttpDatasource.shared.addHttpRequest(model)
    }

    // MARK: - URLSession Delegate

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        client?.urlProtocol(self, didLoad: data)
        responseData.append(data)
    }

    func urlSession(
        _ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse,
        completionHandler: @escaping (URLSession.ResponseDisposition) -> Void
    ) {
        self.response = response
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
        completionHandler(.allow)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        self.error = error
        if let error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            client?.urlProtocolDidFinishLoading(self)
        }
    }

    func canonicalRequest(for request: URLRequest) -> URLRequest {
        var mutableRequest = request

        guard let url = request.url,
              var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else {
            return mutableRequest
        }

        let scheme = components.scheme?.lowercased()

        if scheme == "http" || scheme == "https" {
            components.scheme = scheme

            if let host = components.host?.lowercased() {
                components.host = host
            } else {
                components.host = "localhost"
            }

            if components.path.isEmpty {
                components.path = "/"
            }

            if let newURL = components.url {
                mutableRequest.url = newURL
            }

            if mutableRequest.value(forHTTPHeaderField: "Content-Type") == nil,
               let httpMethod = mutableRequest.httpMethod,
               httpMethod.caseInsensitiveCompare("POST") == .orderedSame,
               mutableRequest.httpBody != nil || mutableRequest.httpBodyStream != nil
            {
                mutableRequest.setValue(
                    "application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type"
                )
            }

            if mutableRequest.value(forHTTPHeaderField: "Accept") == nil {
                mutableRequest.setValue("*/*", forHTTPHeaderField: "Accept")
            }

            if mutableRequest.value(forHTTPHeaderField: "Accept-Encoding") == nil {
                mutableRequest.setValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
            }

            if mutableRequest.value(forHTTPHeaderField: "Accept-Language") == nil {
                mutableRequest.setValue("en-us", forHTTPHeaderField: "Accept-Language")
            }
        }

        return mutableRequest
    }
}

// MARK: - Notification.Name extension

extension Notification.Name {
    static let reloadHttpHeliosTrace = Notification.Name("reloadHttp_HeliosTrace")
}
