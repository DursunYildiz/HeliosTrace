//
//  HeliosTrace.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 10.11.2025.
//

import Foundation
import UIKit

@objc public class HeliosTrace: NSObject {
    /// if the captured URLs contain server URL, HeliosTrace set server URL bold font to be marked. Not mark when this value is nil. Default value is `nil`.
    @objc public static var serverURL: String?
    /// set the URLs which should not been captured, HeliosTrace capture all URLs when the value is nil. Default value is `nil`.
    @objc public static var ignoredURLs: [String]?
    /// set the URLs which are only been captured, HeliosTrace capture all URLs when the value is nil. Default value is `nil`.
    @objc public static var onlyURLs: [String]?
    /// set the prefix Logs which should not been captured, HeliosTrace capture all Logs when the value is nil. Default value is `nil`.
    @objc public static var ignoredPrefixLogs: [String]?
    /// set the prefix Logs which are only been captured, HeliosTrace capture all Logs when the value is nil. Default value is `nil`.
    @objc public static var onlyPrefixLogs: [String]?
    /// add an additional UIViewController as child controller of HeliosTrace's main UITabBarController. Default value is `nil`.
    @objc public static var additionalViewController: UIViewController?
    /// set the initial recipients to include in the email’s “To” field when share via email. Default value is `nil`.
    @objc public static var emailToRecipients: [String]?
    /// set the initial recipients to include in the email’s “Cc” field when share via email. Default value is `nil`.
    @objc public static var emailCcRecipients: [String]?
    /// set HeliosTrace's main color with hexadecimal format. Default value is `#42d459`.
    @objc public static var mainColor: String = "#42d459"
    /// protobuf url and response class transfer map. Default value is `nil`.
    @objc public static var protobufTransferMap: [String: [String]]?

    // MARK: - HeliosTrace enable

    /// You should call this method in your `AppDelegate.swift` file, inside the `application(_:didFinishLaunchingWithOptions:)` method.
    @objc public static func enable() {
        initializationMethod(serverURL: serverURL, ignoredURLs: ignoredURLs, onlyURLs: onlyURLs, ignoredPrefixLogs: ignoredPrefixLogs, onlyPrefixLogs: onlyPrefixLogs, additionalViewController: additionalViewController, emailToRecipients: emailToRecipients, emailCcRecipients: emailCcRecipients, mainColor: mainColor, protobufTransferMap: protobufTransferMap)
    }

    // MARK: - HeliosTrace disable

    @objc public static func disable() {
        deinitializationMethod()
    }

    // MARK: - hide Bubble

    @objc public static func hideBubble() {
        HeliosTraceSettings.shared.showBubbleAndWindow = false
    }

    // MARK: - show Bubble

    @objc public static func showBubble() {
        HeliosTraceSettings.shared.showBubbleAndWindow = true
    }
}

// MARK: - override Swift `print` method

public func print<T>(file: String = #file, function: String = #function, line: Int = #line, _ message: T, color: UIColor = .white) {
    Swift.print(message)
    _SwiftLogHelper.shared.handleLog(file: file, function: function, line: line, message: message, color: color)
}
