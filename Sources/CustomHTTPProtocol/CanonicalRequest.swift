//
//  CanonicalRequest.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 10.11.2025.
//

import Foundation

// MARK: - URL Canonicalization

enum CanonicalRequest {
    /// Canonicalize an NSURLRequest (URL + Headers)
    static func canonicalRequest(for request: URLRequest) -> URLRequest {
        guard var url = request.url,
              let scheme = url.scheme?.lowercased(),
              scheme == "http" || scheme == "https"
        else {
            return request
        }
        
        // Step 1: Normalize URL components
        url = normalizeURL(url)
        
        // Step 2: Canonicalize headers
        let normalizedHeaders = canonicalizeHeaders(in: request)
        
        // Step 3: Recreate the request
        var newRequest = request
        newRequest.url = url
        for (key, value) in normalizedHeaders {
            newRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        return newRequest
    }
    
    // MARK: - URL Normalization
    
    private static func normalizeURL(_ url: URL) -> URL {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return url
        }
        
        // ✅ Scheme lowercase
        components.scheme = components.scheme?.lowercased()
        
        // ✅ Host lowercase (and replace empty host with localhost)
        if let host = components.host {
            components.host = host.lowercased()
        } else {
            components.host = "localhost"
        }
        
        // ✅ Fix empty path → "/"
        if components.path.isEmpty {
            components.path = "/"
        }
        
        // ✅ Remove default ports (optional, but follows the original idea)
        if let port = components.port {
            if (components.scheme == "http" && port == 80) ||
                (components.scheme == "https" && port == 443)
            {
                components.port = nil
            }
        }
        
        // ✅ Ensure "://" separator is correct (handled automatically by URLComponents)
        return components.url ?? url
    }
    
    // MARK: - Header Normalization
    
    private static func canonicalizeHeaders(in request: URLRequest) -> [String: String] {
        var headers = request.allHTTPHeaderFields ?? [:]
        let method = request.httpMethod ?? "GET"
        
        // Add default Content-Type for POSTs
        if headers["Content-Type"] == nil,
           method.uppercased() == "POST",
           request.httpBody != nil || request.httpBodyStream != nil
        {
            headers["Content-Type"] = "application/x-www-form-urlencoded"
        }
        
        // Default Accept
        if headers["Accept"] == nil {
            headers["Accept"] = "*/*"
        }
        
        // Default Accept-Encoding
        if headers["Accept-Encoding"] == nil {
            headers["Accept-Encoding"] = "gzip, deflate"
        }
        
        // Default Accept-Language
        if headers["Accept-Language"] == nil {
            headers["Accept-Language"] = "en-us"
        }
        
        return headers
    }
}
