import UIKit

// MARK: - Enums (ObjC typedef'lerin Swift karşılığı)

enum HeliosTraceLogType: Int {
    case normal = 0
    case rn
    case web
}

enum HeliosTraceToolType: Int {
    case none
    case rn
    case json
    case protobuf
}

// MARK: - Model

import Foundation

final class OCLogModel {
    // MARK: - Properties
    
    var contentData: Data?
    
    var id: String
    var fileInfo: String
    var content: String
    var date: Date
    var color: UIColor
    
    var isTag: Bool
    var isSelected: Bool = false
    
    var str: String = ""
    var attr: NSAttributedString = .init()
    
    var logType: HeliosTraceLogType = .normal
    
    // MARK: - Init
    
    init(content: String,
         color: UIColor,
         fileInfo: String,
         isTag: Bool,
         type: HeliosTraceToolType)
    {
        var finalFileInfo = fileInfo
        var finalContent = content
        
        // MARK: - File Info Düzenleme
        
        if fileInfo == "XXX|XXX|1" {
            finalFileInfo = (type == .protobuf) ? "Protobuf\n" : "\n"
        }
        
        if type == .none {
            if fileInfo == " \n" {
                finalFileInfo = "NSLog\n"
            } else if fileInfo == "\n" {
                finalFileInfo = "\n"
            }
        }
        
        // React Native log etiketi dönüştürme
        if fileInfo == "[RCTLogError]\n" {
            finalFileInfo = "[error]\n"
        } else if fileInfo == "[RCTLogInfo]\n" {
            finalFileInfo = "[log]\n"
        }
        
        // MARK: - Özellikler

        self.id = UUID().uuidString
        self.fileInfo = finalFileInfo
        self.date = Date()
        self.color = color
        self.isTag = isTag
        
        // İçerik verisi
        if let data = finalContent.data(using: .utf8) {
            self.contentData = data
        }
        
        // İçeriği sınırla (performans için)
        if finalContent.count > 1000 {
            finalContent = String(finalContent.prefix(1000))
        }
        self.content = finalContent
        
        // MARK: - Attributed String Oluşturma
        
        var stringContent = "[\(OCLoggerFormat.formatDate(self.date))]"
        let lengthDate = stringContent.count
        let startIndex = stringContent.count
        
        if !self.fileInfo.isEmpty {
            stringContent += "\(self.fileInfo)\(self.content)"
        } else {
            stringContent += self.content
        }
        
        let attributedString = NSMutableAttributedString(string: stringContent)
        
        // Tüm metin rengi
        attributedString.addAttribute(.foregroundColor,
                                      value: self.color,
                                      range: NSRange(location: 0, length: stringContent.count))
        
        // Tarih kısmı rengi (mainColor)
        let dateRange = NSRange(location: 0, length: lengthDate)
        attributedString.addAttribute(.foregroundColor,
                                      value: NetworkHelper.shared.mainColor,
                                      range: dateRange)
        attributedString.addAttribute(.font,
                                      value: UIFont.boldSystemFont(ofSize: 12),
                                      range: dateRange)
        
        // fileInfo kısmı (gri veya kırmızı)
        let fileInfoRange = NSRange(location: startIndex, length: self.fileInfo.count)
        if self.fileInfo == "[error]\n" {
            attributedString.addAttribute(.foregroundColor, value: UIColor.systemRed, range: fileInfoRange)
        } else {
            attributedString.addAttribute(.foregroundColor, value: UIColor.systemGray, range: fileInfoRange)
        }
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 12), range: fileInfoRange)
        
        // Satır kırma stili
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byCharWrapping
        attributedString.addAttribute(.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSRange(location: 0, length: attributedString.length))
        
        // MARK: - Sonuç

        self.str = stringContent
        self.attr = attributedString.copy() as! NSAttributedString
    }
}
