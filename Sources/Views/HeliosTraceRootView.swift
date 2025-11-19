//
//  HeliosTraceRootView.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 11.11.2025.
//

import SwiftUI

struct HeliosTraceRootView: View {
    @State private var showTabbar: Bool = false

    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()

            BubbleRepresentable(onTap: {
                WindowHelper.shared.displayedList = true
                showTabbar = true
            })
            .ignoresSafeArea()

            if HeliosTraceSettings.shared.enableUIBlockingMonitoring {
                UIBlockingBubbleRepresentable()
                    .ignoresSafeArea()
            }
        }
        .background(Color.clear)
        .fullScreenCover(isPresented: $showTabbar, onDismiss: {
            WindowHelper.shared.displayedList = false
        }) {
            TabbarView()
                .background(Color.white)
        }
    }
}

// MARK: - BubbleRepresentable

private struct BubbleRepresentable: UIViewRepresentable {
    let onTap: () -> Void

    func makeUIView(context: Context) -> UIView {
        let bubble = Bubble(frame: CGRect(origin: .zero, size: Bubble.size))
        bubble.center = Bubble.originalPosition
        bubble.delegate = context.coordinator
        WindowHelper.shared.bubbleView = bubble
        context.coordinator.onTap = onTap
        return bubble
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        uiView.center = Bubble.originalPosition
        WindowHelper.shared.bubbleView = uiView
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator: NSObject, BubbleDelegate {
        var onTap: (() -> Void)?
        func didTapBubble() {
            onTap?()
        }
    }
}

// MARK: - UIBlockingBubbleRepresentable

private struct UIBlockingBubbleRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> UIBlockingBubble {
        let view = UIBlockingBubble(frame: CGRect(origin: .zero, size: UIBlockingBubble.size))
        return view
    }

    func updateUIView(_ uiView: UIBlockingBubble, context: Context) {
        uiView.updateFrame()
    }
}

