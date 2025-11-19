//
//  UIBlockingBubble.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldız on 10.11.2025.
//

import UIKit

class UIBlockingBubble: UIView {
    static var size: CGSize { return CGSize(width: 70, height: 20) }
    
    private var uiBlockingLabel: UILabel? = UILabel(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    
    fileprivate func initLayer() {
        backgroundColor = .black
        layer.cornerRadius = 4
        sizeToFit()
        
        if let uiBlockingLabel = uiBlockingLabel {
            addSubview(uiBlockingLabel)
        }
    }
    
    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: CGRect(x: UIScreen.main.bounds.width / 4.0, y: 1, width: frame.width, height: frame.height))
        
        initLayer()
        
        uiBlockingLabel?.textAlignment = .center
        uiBlockingLabel?.adjustsFontSizeToFitWidth = true
        uiBlockingLabel?.text = "Normal"
        uiBlockingLabel?.textColor = .white
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "HeliosTrace_Detected_UI_Blocking"), object: nil, queue: OperationQueue.main) { [weak self] _ in
            self?.uiBlockingLabel?.text = "Blocking"
            self?.uiBlockingLabel?.textColor = .red
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
                self?.uiBlockingLabel?.text = "Normal"
                self?.uiBlockingLabel?.textColor = .white
            }
        }
    }
    
    func updateFrame() {
        // view üstünde çalışıyorsan en doğrusu budur
        let topInset = safeAreaInsets.top
            
        // notch cihazlar genelde 44+ içeriğe sahiptir
        if topInset > 24 {
            center.x = UIScreen.main.bounds.width / 2.0
            center.y = topInset + 15 // iPhone X, 12, 13, 14, 15 hepsi için ideal
        } else {
            // normal cihazlar (SE, 8 vb.)
            center.x = UIScreen.main.bounds.width / 2.0
            center.y = 39
        }
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        // notification
        NotificationCenter.default.removeObserver(self)
    }
}
