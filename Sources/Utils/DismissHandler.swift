//
//  DismissHandler.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 12.11.2025.
//

import SwiftUI

/// A wrapper to provide backward compatibility for dismissing views.
struct DismissHandler {
    private let dismissAction: (() -> Void)?

    init(_ dismissAction: (() -> Void)? = nil) {
        self.dismissAction = dismissAction
    }

    func callAsFunction() {
        if let dismissAction {
            dismissAction()
        } else {
            // iOS 14 fallback: try to pop manually
            if let rootVC = UIApplication.shared.windows.first?.rootViewController {
                rootVC.dismiss(animated: true, completion: nil)
            }
        }
    }
}

struct DismissEnvironmentKey: EnvironmentKey {
    static let defaultValue = DismissHandler()
}

extension EnvironmentValues {
    var safeDismiss: DismissHandler {
        get { self[DismissEnvironmentKey.self] }
        set { self[DismissEnvironmentKey.self] = newValue }
    }
}

extension View {
    func withSafeDismiss() -> some View {
        Group {
            if #available(iOS 15.0, *) {
                self.modifier(SafeDismissModifier_iOS15())
            } else {
                self.modifier(SafeDismissModifier_Legacy())
            }
        }
    }
}

@available(iOS 15.0, *)
private struct SafeDismissModifier_iOS15: ViewModifier {
    @Environment(\.dismiss) private var dismiss

    func body(content: Content) -> some View {
        content.environment(\.safeDismiss, DismissHandler {
            dismiss()
        })
    }
}

private struct SafeDismissModifier_Legacy: ViewModifier {
    func body(content: Content) -> some View {
        content.environment(\.safeDismiss, DismissHandler {
            if let rootVC = UIApplication.shared.windows.first?.rootViewController {
                rootVC.dismiss(animated: true, completion: nil)
            }
        })
    }
}
