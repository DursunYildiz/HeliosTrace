 
//
//  _SwiftLogHelper.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 11.11.2025.
//

import Foundation
import UIKit

public class _SwiftLogHelper: NSObject {
    var enable: Bool = true
    
    @objc public static let shared = _SwiftLogHelper()
    override private init() {}
    
    fileprivate func parseFileInfo(file: String?, function: String?, line: Int?) -> String? {
        guard let file = file, let function = function, let line = line, let fileName = file.components(separatedBy: "/").last else { return nil }
        return "\(fileName)[\(line)]\(function)\n"
    }
    
    public func handleLog(file: String?, function: String?, line: Int?, message: Any..., color: UIColor?) {
        let stringContent = message.reduce("") { result, next -> String in
            return "\(result)\(result.count > 0 ? " " : "")\(next)"
        }
        commonHandleLog(file: file, function: function, line: line ?? 0, message: stringContent, color: color)
    }
    
    private func commonHandleLog(file: String?, function: String?, line: Int, message: String, color: UIColor?) {
        guard enable else {
            return
        }
        
        // 1.
        guard let fileInfo = parseFileInfo(file: file, function: function, line: line) else { return }
        
        // 2.
        let newLog = OCLogModel(content: message, color: color ?? .red, fileInfo: fileInfo, isTag: false, type: .none)
        OCLogStoreManager.shared.addLog(newLog)
    
        // 3.
        NotificationCenter.default.post(name: NSNotification.Name("refreshLogs_HeliosTrace"), object: nil, userInfo: nil)
    }
}
