//
//  OCLogHelper.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 10.11.2025.
//

import UIKit

import UIKit

final class OCLogHelper {
    // MARK: - Singleton

    static let shared = OCLogHelper()
    private init() {}
    
    // MARK: - Properties

    var enable: Bool = true // ObjC'de varsayılan olarak YES
    
    // MARK: - Public Methods
    
    func parseFileInfo(file: String, function: String, line: Int) -> String {
        guard !file.isEmpty, !function.isEmpty else { return "\n" }
        
        if file == "XXX", function == "XXX", line == 1 {
            return "XXX|XXX|1"
        }
        
        switch line {
        case 0: // Web
            let fileName = (file as NSString).lastPathComponent
            return "\(fileName) \(function)\n"
            
        case 999_999_999: // NSLog
            let fileName = (file as NSString).lastPathComponent
            return "\(fileName) \(function)\n"
            
        case -1: // React Native
            return file
            
        default:
            let fileName = (file as NSString).lastPathComponent
            return "\(fileName)[\(line)]\(function)\n"
        }
    }
    
    func handleLog(file: String,
                   function: String,
                   line: Int,
                   message: String,
                   color: UIColor,
                   type: HeliosTraceToolType)
    {
        // Loglama kapalıysa ve RN değilse atla
        // if !enable && type != .rn { return }
        guard !file.isEmpty, !function.isEmpty, !message.isEmpty else { return }
        
        // 1️⃣ File info oluştur
        let fileInfo = parseFileInfo(file: file, function: function, line: line)
        
        // 2️⃣ Log modeli oluştur
        let newLog = OCLogModel(content: message,
                                color: color,
                                fileInfo: fileInfo,
                                isTag: false,
                                type: type)
        
        // 3️⃣ Store’a ekle
        OCLogStoreManager.shared.addLog(newLog)
        
        // 4️⃣ Notification gönder
        NotificationCenter.default.post(name: .refreshHeliosTraceLogs, object: nil)
    }
}
 
extension Notification.Name {
    static let refreshHeliosTraceLogs = Notification.Name("refreshLogs_HeliosTrace")
}
