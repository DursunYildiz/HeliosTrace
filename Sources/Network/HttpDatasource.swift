//
//  HttpDatasource.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 10.11.2025.
//

import Foundation

public final class HttpDatasource {
    // MARK: - Singleton

    public static let shared = HttpDatasource()
    
    // MARK: - Properties

    public private(set) var httpModels: [HttpModel] = []
    private let maxCount = 1000
    
    private init() {}
    
    // MARK: - Public Methods
    
    /// Yeni bir HTTP isteğini kaydeder.
    /// - Returns: Eğer kayıt başarılıysa `true`, aksi halde `false`
    @discardableResult
    func addHttpRequest(_ model: HttpModel) -> Bool {
        // URL filtreleme (ignore case)
        for urlString in NetworkHelper.shared.ignoredURLs ?? [] {
            if let host = model.url?.host, host.lowercased().contains(urlString.lowercased()) {
                return false
            }
         }
        
        // Maksimum kayıt sınırı
        if httpModels.count >= maxCount {
            httpModels.removeFirst()
        }
        
        // Yinelenen isteği kontrol et
        if httpModels.contains(where: { $0.requestId == model.requestId }) {
            return false
        }
        
        // Ekle
        httpModels.append(model)
        return true
    }
    
    /// Tüm kayıtları temizler.
    public func reset() {
        httpModels.removeAll()
    }
    
    /// Belirli bir modeli siler.
    func remove(_ model: HttpModel) {
        httpModels.removeAll { $0.requestId == model.requestId }
    }
}
