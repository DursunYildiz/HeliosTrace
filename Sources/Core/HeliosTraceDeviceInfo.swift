//
//  HeliosTrace
//  HeliosTraceDeviceInfo.swift
//
//  Created by Dursun  Yıldız 02/02/2023.
//

import Foundation
import UIKit

class HeliosTraceDeviceInfo {
    static let shared = HeliosTraceDeviceInfo()
    
    private init() {}
    
    var systemType: String {
        return UIDevice.current.systemName
    }
    
    var userName: String {
        return UIDevice.current.name
    }
    
    var systemVersion: String {
        return UIDevice.current.systemVersion
    }
    
    var deviceModel: String {
        return UIDevice.current.model
    }
    
    var deviceUUID: String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    var deviceName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    var getPlatformString: String? {
        return DeviceUtil.shared.hardwareSimpleDescription()
    }
    
    var localizedModel: String {
        return UIDevice.current.localizedModel
    }
    
    var appVersion: String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var appBuiltVersion: String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
    
    var appBundleID: String? {
        return Bundle.main.bundleIdentifier
    }
    
    var appBundleName: String? {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String
    }
    
    var resolution: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: UIScreen.main.bounds.width * scale, height: UIScreen.main.bounds.height * scale)
    }
}
