//
//  WindowHelper.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 10.11.2025.
//

import SwiftUI
import UIKit

public class WindowHelper: NSObject {
    public static let shared = WindowHelper()

    var window: HeliosTraceWindow
    var displayedList = false
    weak var bubbleView: UIView?
    lazy var vc: UIViewController = {
        let vc = OverlayRootViewController()
        vc.view.backgroundColor = .clear
        vc.view.isOpaque = false
        return vc
    }() // must lazy init, otherwise crash

    // UIBlocking
    //    fileprivate var uiBlockingCounter = UIBlockingCounter()
    //    var uiBlockingCallback:((Int) -> Void)?

    override private init() {
        window = HeliosTraceWindow(frame: UIScreen.main.bounds)
        // This is for making the window not to effect the StatusBarStyle
        window.bounds.size.height = UIScreen.main.bounds.height.nextDown
        super.init()

        //        uiBlockingCounter.delegate = self
    }

    public func enable() {
        if window.rootViewController == vc {
            return
        }

        // Attach to active scene first to avoid black background due to scene mismatch
        if #available(iOS 13.0, *) {
            if let activeScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive })
            {
                window.windowScene = activeScene
            }
        }

        window.rootViewController = vc
        window.delegate = self
        window.isHidden = false

        if HeliosTraceSettings.shared.enableUIBlockingMonitoring == true {
            startUIBlockingMonitoring()
        }

        if #available(iOS 13.0, *) {
            var success = window.windowScene != nil

            if success == false {
                for i in 0 ... 10 {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + (0.1 * Double(i))) {
                        [weak self] in
                        guard let self else { return }
                        if success == true { return }
                        if let activeScene = UIApplication.shared.connectedScenes
                            .compactMap({ $0 as? UIWindowScene })
                            .first(where: { $0.activationState == .foregroundActive })
                        {
                            self.window.windowScene = activeScene
                            success = true
                        }
                    }
                }
            }
        }
    }

    public func disable() {
        if window.rootViewController == nil {
            return
        }
        window.rootViewController = nil
        window.delegate = nil
        window.isHidden = true
        stopUIBlockingMonitoring()
    }

    public func startUIBlockingMonitoring() {}

    public func stopUIBlockingMonitoring() {}
}

// MARK: - UIBlockingCounterDelegate

// extension WindowHelper: UIBlockingCounterDelegate {
//    @objc public func uiBlockingCounter(_ counter: UIBlockingCounter, didUpdateFramesPerSecond uiBlocking: Int) {
//        if let uiBlockingCallback = uiBlockingCallback {
//            uiBlockingCallback(uiBlocking)
//        }
//    }
// }
