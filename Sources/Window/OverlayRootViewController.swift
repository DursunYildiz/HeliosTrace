//
//  OverlayRootViewController.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 11.11.2025.
//

import SwiftUI
import UIKit

final class OverlayRootViewController: UIViewController {
    private let bubble = Bubble(frame: CGRect(origin: .zero, size: Bubble.size))
    private var uiBlockingBubble: UIBlockingBubble?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.isOpaque = false

        bubble.center = Bubble.originalPosition
        bubble.delegate = self
        view.addSubview(bubble)
        WindowHelper.shared.bubbleView = bubble

        if HeliosTraceSettings.shared.enableUIBlockingMonitoring {
            let uiBubble = UIBlockingBubble(frame: CGRect(origin: .zero, size: UIBlockingBubble.size))
            uiBlockingBubble = uiBubble
            view.addSubview(uiBubble)
            uiBubble.updateFrame()
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.backgroundColor = .clear
        view.isOpaque = false
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] _ in
            guard let self else { return }
            self.bubble.updateOrientation(newSize: size)
            self.uiBlockingBubble?.updateFrame()
        }, completion: nil)
    }
}

extension OverlayRootViewController: BubbleDelegate {
    func didTapBubble() {
        WindowHelper.shared.displayedList = true
        let vc = UIHostingController(rootView: TabbarView())
        vc.view.backgroundColor = .white
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}
