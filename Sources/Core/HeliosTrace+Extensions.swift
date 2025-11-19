
import Foundation
import UIKit

extension HeliosTrace {
    /// init
    static func initializationMethod(serverURL: String? = nil, ignoredURLs: [String]? = nil, onlyURLs: [String]? = nil, ignoredPrefixLogs: [String]? = nil, onlyPrefixLogs: [String]? = nil, additionalViewController: UIViewController? = nil, emailToRecipients: [String]? = nil, emailCcRecipients: [String]? = nil, mainColor: String? = nil, protobufTransferMap: [String: [String]]? = nil) {
        if serverURL == nil {
            HeliosTraceSettings.shared.serverURL = ""
        } else {
            HeliosTraceSettings.shared.serverURL = serverURL
        }

        if ignoredURLs == nil {
            HeliosTraceSettings.shared.ignoredURLs = []
        } else {
            HeliosTraceSettings.shared.ignoredURLs = ignoredURLs
        }
        if onlyURLs == nil {
            HeliosTraceSettings.shared.onlyURLs = []
        } else {
            HeliosTraceSettings.shared.onlyURLs = onlyURLs
        }

        if ignoredPrefixLogs == nil {
            HeliosTraceSettings.shared.ignoredPrefixLogs = []
        } else {
            HeliosTraceSettings.shared.ignoredPrefixLogs = ignoredPrefixLogs
        }
        if onlyPrefixLogs == nil {
            HeliosTraceSettings.shared.onlyPrefixLogs = []
        } else {
            HeliosTraceSettings.shared.onlyPrefixLogs = onlyPrefixLogs
        }

        if HeliosTraceSettings.shared.firstIn == nil { // first launch
            HeliosTraceSettings.shared.firstIn = ""
            HeliosTraceSettings.shared.showBubbleAndWindow = true
        } else { // not first launch
            HeliosTraceSettings.shared.showBubbleAndWindow = HeliosTraceSettings.shared.showBubbleAndWindow
        }

        HeliosTraceSettings.shared.visible = false
        HeliosTraceSettings.shared.logSearchWordNormal = nil
        HeliosTraceSettings.shared.logSearchWordRN = nil
        HeliosTraceSettings.shared.logSearchWordWeb = nil
        HeliosTraceSettings.shared.networkSearchWord = nil
        HeliosTraceSettings.shared.protobufTransferMap = protobufTransferMap
        HeliosTraceSettings.shared.additionalViewController = additionalViewController

        HeliosTraceSettings.shared.responseShake = true

        // share via email
        HeliosTraceSettings.shared.emailToRecipients = emailToRecipients
        HeliosTraceSettings.shared.emailCcRecipients = emailCcRecipients

        // color
        HeliosTraceSettings.shared.mainColor = mainColor ?? "#42d459"

        // slow animations
        HeliosTraceSettings.shared.slowAnimations = false

        // log
        let enableLogMonitoring = UserDefaults.standard.bool(forKey: "enableLogMonitoring_HeliosTrace")

        _SwiftLogHelper.shared.enable = enableLogMonitoring
        OCLogHelper.shared.enable = enableLogMonitoring

        // network
        let disableNetworkMonitoring = UserDefaults.standard.bool(forKey: "disableNetworkMonitoring_HeliosTrace")
        if disableNetworkMonitoring == true {
            NetworkHelper.shared.disable()
        } else {
            NetworkHelper.shared.enable()
        }
    }

    /// deinit
    static func deinitializationMethod() {
        WindowHelper.shared.disable()
        NetworkHelper.shared.disable()
        _SwiftLogHelper.shared.enable = false
        HeliosTraceSettings.shared.responseShake = false
    }
}
