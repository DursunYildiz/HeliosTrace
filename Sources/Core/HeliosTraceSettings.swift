//
//  HeliosTraceSettings.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 10.11.2025.
//

import Foundation
import UIKit

@objc public class HeliosTraceSettings: NSObject {
    @objc public static let shared = HeliosTraceSettings()

    @objc public var slowAnimations: Bool = false {
        didSet {
            if slowAnimations == false {
                UIApplication.shared.windows.first?.layer.speed = 1
            } else {
                UIApplication.shared.windows.first?.layer.speed = 0.1
            }
        }
    }

    @objc public var responseShake: Bool = false {
        didSet {
            UserDefaults.standard.set(responseShake, forKey: "responseShake_HeliosTrace")
            UserDefaults.standard.synchronize()
        }
    }

    @objc public var firstIn: String? {
        didSet {
            UserDefaults.standard.set(firstIn, forKey: "firstIn_HeliosTrace")
            UserDefaults.standard.synchronize()
        }
    }

    @objc public var enableCrashRecording: Bool = false {
        didSet {
            UserDefaults.standard.set(enableCrashRecording, forKey: "enableCrashRecording_HeliosTrace")
            UserDefaults.standard.synchronize()
        }
    }

    @objc public var enableUIBlockingMonitoring: Bool = false {
        didSet {
            UserDefaults.standard.set(enableUIBlockingMonitoring, forKey: "enableUIBlockingMonitoring_HeliosTrace")
            UserDefaults.standard.synchronize()
        }
    }

    @objc public var enableWKWebViewMonitoring: Bool = false {
        didSet {
            UserDefaults.standard.set(enableWKWebViewMonitoring, forKey: "enableWKWebViewMonitoring_HeliosTrace")
            UserDefaults.standard.synchronize()
        }
    }

    @objc public var enableLogMonitoring: Bool = false {
        didSet {
            UserDefaults.standard.set(enableLogMonitoring, forKey: "enableLogMonitoring_HeliosTrace")
            UserDefaults.standard.synchronize()
        }
    }

    @objc public var disableNetworkMonitoring: Bool = false {
        didSet {
            UserDefaults.standard.set(disableNetworkMonitoring, forKey: "disableNetworkMonitoring_HeliosTrace")
            UserDefaults.standard.synchronize()
        }
    }

    @objc public var enableRNMonitoring: Bool = false {
        didSet {
            UserDefaults.standard.set(enableRNMonitoring, forKey: "enableRNMonitoring_HeliosTrace")
            UserDefaults.standard.synchronize()
        }
    }

    @objc public var enableMemoryLeaksMonitoring_ViewController: Bool = false {
        didSet {
            UserDefaults.standard.set(enableMemoryLeaksMonitoring_ViewController, forKey: "enableMemoryLeaksMonitoring_UIViewController_HeliosTrace")
            UserDefaults.standard.synchronize()
        }
    }

    @objc public var enableMemoryLeaksMonitoring_View: Bool = false {
        didSet {
            UserDefaults.standard.set(enableMemoryLeaksMonitoring_View, forKey: "enableMemoryLeaksMonitoring_UIView_HeliosTrace")
            UserDefaults.standard.synchronize()
        }
    }

    @objc public var enableMemoryLeaksMonitoring_MemberVariables: Bool = false {
        didSet {
            UserDefaults.standard.set(enableMemoryLeaksMonitoring_MemberVariables, forKey: "enableMemoryLeaksMonitoring_MemberVariables_HeliosTrace")
            UserDefaults.standard.synchronize()
        }
    }

    @objc public var visible: Bool = false {
        didSet {
            UserDefaults.standard.set(visible, forKey: "visible_HeliosTrace")
            UserDefaults.standard.synchronize()
        }
    }

    @objc public var showBubbleAndWindow: Bool = false {
        didSet {
            UserDefaults.standard.set(showBubbleAndWindow, forKey: "showBubbleAndWindow_HeliosTrace")
            UserDefaults.standard.synchronize()

            if showBubbleAndWindow == true {
                WindowHelper.shared.enable()
            } else {
                WindowHelper.shared.disable()
            }
        }
    }

    @objc public var serverURL: String? {
        didSet {
            UserDefaults.standard.set(serverURL, forKey: "serverURL_HeliosTrace")
            UserDefaults.standard.synchronize()
        }
    }

    @objc public var tabBarSelectItem: Int {
        didSet {
            UserDefaults.standard.set(tabBarSelectItem, forKey: "tabBarSelectItem_HeliosTrace")
            UserDefaults.standard.synchronize()
        }
    }

    @objc public var logSelectIndex: Int {
        didSet {
            UserDefaults.standard.set(logSelectIndex, forKey: "logSelectIndex_HeliosTrace")
            UserDefaults.standard.synchronize()
        }
    }

    @objc public var networkLastIndex: Int {
        didSet {
            UserDefaults.standard.set(networkLastIndex, forKey: "networkLastIndex_HeliosTrace")
            UserDefaults.standard.synchronize()
        }
    }

    @objc public var bubbleFrameX: Float {
        didSet {
            UserDefaults.standard.set(bubbleFrameX, forKey: "bubbleFrameX_HeliosTrace")
            UserDefaults.standard.synchronize()
        }
    }

    @objc public var bubbleFrameY: Float {
        didSet {
            UserDefaults.standard.set(bubbleFrameY, forKey: "bubbleFrameY_HeliosTrace")
            UserDefaults.standard.synchronize()
        }
    }

    @objc public var logSearchWordNormal: String? {
        didSet {
            UserDefaults.standard.set(logSearchWordNormal, forKey: "logSearchWordNormal_HeliosTrace")
            UserDefaults.standard.synchronize()
        }
    }

    @objc public var logSearchWordRN: String? {
        didSet {
            UserDefaults.standard.set(logSearchWordRN, forKey: "logSearchWordRN_HeliosTrace")
            UserDefaults.standard.synchronize()
        }
    }

    @objc public var logSearchWordWeb: String? {
        didSet {
            UserDefaults.standard.set(logSearchWordWeb, forKey: "logSearchWordWeb_HeliosTrace")
            UserDefaults.standard.synchronize()
        }
    }

    @objc public var networkSearchWord: String? {
        didSet {
            UserDefaults.standard.set(networkSearchWord, forKey: "networkSearchWord_HeliosTrace")
            UserDefaults.standard.synchronize()
        }
    }

    @objc public var mainColor: String {
        didSet {
            UserDefaults.standard.set(mainColor, forKey: "mainColor_HeliosTrace")
            UserDefaults.standard.synchronize()
        }
    }

    @objc public var additionalViewController: UIViewController?

    // share via email
    @objc public var emailToRecipients: [String]?
    @objc public var emailCcRecipients: [String]?

    // objc

    @objc public var ignoredURLs: [String]? {
        didSet {
            NetworkHelper.shared.ignoredURLs = ignoredURLs
        }
    }

    @objc public var onlyURLs: [String]? {
        didSet {
            NetworkHelper.shared.onlyURLs = onlyURLs
        }
    }

    @objc public var ignoredPrefixLogs: [String]? {
        didSet {
            NetworkHelper.shared.ignoredPrefixLogs = ignoredPrefixLogs
        }
    }

    @objc public var onlyPrefixLogs: [String]? {
        didSet {
            NetworkHelper.shared.onlyPrefixLogs = onlyPrefixLogs
        }
    }

    // protobuf
    @objc public var protobufTransferMap: [String: [String]]? {
        didSet {
            NetworkHelper.shared.protobufTransferMap = protobufTransferMap
        }
    }

    override private init() {
        responseShake = UserDefaults.standard.bool(forKey: "responseShake_HeliosTrace")
        firstIn = UserDefaults.standard.string(forKey: "firstIn_HeliosTrace")
        serverURL = UserDefaults.standard.string(forKey: "serverURL_HeliosTrace")
        visible = UserDefaults.standard.bool(forKey: "visible_HeliosTrace")
        showBubbleAndWindow = UserDefaults.standard.bool(forKey: "showBubbleAndWindow_HeliosTrace")
        enableCrashRecording = UserDefaults.standard.bool(forKey: "enableCrashRecording_HeliosTrace")
        enableUIBlockingMonitoring = UserDefaults.standard.bool(forKey: "enableUIBlockingMonitoring_HeliosTrace")
        enableWKWebViewMonitoring = UserDefaults.standard.bool(forKey: "enableWKWebViewMonitoring_HeliosTrace")
        enableLogMonitoring = UserDefaults.standard.bool(forKey: "enableLogMonitoring_HeliosTrace")
        disableNetworkMonitoring = UserDefaults.standard.bool(forKey: "disableNetworkMonitoring_HeliosTrace")
        enableRNMonitoring = UserDefaults.standard.bool(forKey: "enableRNMonitoring_HeliosTrace")
        tabBarSelectItem = UserDefaults.standard.integer(forKey: "tabBarSelectItem_HeliosTrace")
        logSelectIndex = UserDefaults.standard.integer(forKey: "logSelectIndex_HeliosTrace")
        networkLastIndex = UserDefaults.standard.integer(forKey: "networkLastIndex_HeliosTrace")
        bubbleFrameX = UserDefaults.standard.float(forKey: "bubbleFrameX_HeliosTrace")
        bubbleFrameY = UserDefaults.standard.float(forKey: "bubbleFrameY_HeliosTrace")
        logSearchWordNormal = UserDefaults.standard.string(forKey: "logSearchWordNormal_HeliosTrace")
        logSearchWordRN = UserDefaults.standard.string(forKey: "logSearchWordRN_HeliosTrace")
        logSearchWordWeb = UserDefaults.standard.string(forKey: "logSearchWordWeb_HeliosTrace")
        networkSearchWord = UserDefaults.standard.string(forKey: "networkSearchWord_HeliosTrace")
        mainColor = UserDefaults.standard.string(forKey: "mainColor_HeliosTrace") ?? "#42d459"

        // objc

        ignoredURLs = NetworkHelper.shared.ignoredURLs
        onlyURLs = NetworkHelper.shared.onlyURLs

        ignoredPrefixLogs = NetworkHelper.shared.ignoredPrefixLogs
        onlyPrefixLogs = NetworkHelper.shared.onlyPrefixLogs

        // protobuf
        protobufTransferMap = NetworkHelper.shared.protobufTransferMap

        // Memory
        enableMemoryLeaksMonitoring_ViewController = UserDefaults.standard.bool(forKey: "enableMemoryLeaksMonitoring_UIViewController_HeliosTrace")
        enableMemoryLeaksMonitoring_View = UserDefaults.standard.bool(forKey: "enableMemoryLeaksMonitoring_UIView_HeliosTrace")
        enableMemoryLeaksMonitoring_MemberVariables = UserDefaults.standard.bool(forKey: "enableMemoryLeaksMonitoring_MemberVariables_HeliosTrace")
    }
}
