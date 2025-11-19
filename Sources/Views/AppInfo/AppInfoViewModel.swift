//
//  AppInfoViewModel.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 12.11.2025.
//

import SwiftUI
import UIKit

// MARK: - ViewModel

final class AppInfoViewModel: ObservableObject {
    // Published states
    @Published var logMonitoring: Bool
    @Published var networkMonitoring: Bool
    @Published var rnMonitoring: Bool
    @Published var webViewMonitoring: Bool
    @Published var slowAnimations: Bool
    @Published var crashRecording: Bool
    @Published var uiBlocking: Bool
    
    @Published var showRestartAlert = false
    @Published var showClipboardSheet = false
    @Published var clipboardContent: String = ""
    
    init() {
        self.logMonitoring = HeliosTraceSettings.shared.enableLogMonitoring
        self.networkMonitoring = !HeliosTraceSettings.shared.disableNetworkMonitoring
        self.rnMonitoring = HeliosTraceSettings.shared.enableRNMonitoring
        self.webViewMonitoring = HeliosTraceSettings.shared.enableWKWebViewMonitoring
        self.slowAnimations = HeliosTraceSettings.shared.slowAnimations
        self.crashRecording = HeliosTraceSettings.shared.enableCrashRecording
        self.uiBlocking = HeliosTraceSettings.shared.enableUIBlockingMonitoring
    }
    
    // MARK: - Actions
    
    func toggleLogMonitoring(_ value: Bool) {
        HeliosTraceSettings.shared.enableLogMonitoring = value
        showRestartAlert = true
    }
    
    func toggleNetworkMonitoring(_ value: Bool) {
        HeliosTraceSettings.shared.disableNetworkMonitoring = !value
        showRestartAlert = true
    }
    
    func toggleRNMonitoring(_ value: Bool) {
        HeliosTraceSettings.shared.enableRNMonitoring = value
        showRestartAlert = true
    }
    
    func toggleWebViewMonitoring(_ value: Bool) {
        HeliosTraceSettings.shared.enableWKWebViewMonitoring = value
        showRestartAlert = true
    }
    
    func toggleSlowAnimations(_ value: Bool) {
        HeliosTraceSettings.shared.slowAnimations = value
    }
    
    func toggleCrashRecording(_ value: Bool) {
        HeliosTraceSettings.shared.enableCrashRecording = value
        showRestartAlert = true
    }
    
    func toggleUIBlocking(_ value: Bool) {
        HeliosTraceSettings.shared.enableUIBlockingMonitoring = value
        if value {
            WindowHelper.shared.startUIBlockingMonitoring()
        } else {
            WindowHelper.shared.stopUIBlockingMonitoring()
        }
    }
    
    func copyToClipboard(_ value: String) {
        clipboardContent = value
        UIPasteboard.general.string = value
        showClipboardSheet = true
    }
    
    func appInfoFields() -> [(title: String, value: String)] {
        [
            ("Bundle Name", HeliosTraceDeviceInfo.shared.appBundleName ?? ""),
            ("Bundle ID", HeliosTraceDeviceInfo.shared.appBundleID ?? ""),
            ("Version", HeliosTraceDeviceInfo.shared.appVersion ?? ""),
            ("Build", HeliosTraceDeviceInfo.shared.appBuiltVersion ?? ""),
            ("Server URL", HeliosTraceSettings.shared.serverURL ?? "")
        ]
    }
    
    func deviceInfoFields() -> [(title: String, value: String)] {
        [
            ("Device", HeliosTraceDeviceInfo.shared.getPlatformString ?? ""),
            ("iOS Version", UIDevice.current.systemVersion),
            ("Resolution", "\(Int(HeliosTraceDeviceInfo.shared.resolution.width)) * \(Int(HeliosTraceDeviceInfo.shared.resolution.height))"),
            ("Crash Count", "\(UserDefaults.standard.integer(forKey: "crashCount_HeliosTrace"))")
        ]
    }
}
