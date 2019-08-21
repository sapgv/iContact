//
//  Alert.swift
//  iContact
//
//  Created by Grigoriy Sapogov on 21/08/2019.
//  Copyright © 2019 Grigoriy Sapogov. All rights reserved.
//

import UIKit

class Alert: UIButton {
    
    public var height: CGFloat = 64
    public var duration = 0.3
    public var delay: Double = 2.0
    
    private let screenWidth = UIScreen.main.bounds.size.width
    private let screenHeight = UIScreen.main.bounds.size.height
    private let padding: CGFloat = 16
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init() {
        super.init(frame: CGRect.zero)
        self.frame = CGRect(x: padding/2, y: screenHeight + height + padding/2, width: screenWidth - padding, height: height)
        self.layer.cornerRadius = 10
        self.addTarget(self, action: #selector(viewDidTap), for: .touchUpInside)
    }
    
    @objc func viewDidTap() {
        hide(self)
    }
    
    // MARK: - Hub methods
    
    @objc private func show(_ title: String, backgroundColor: UIColor?) {
        
        addWindowSubview(self)
        self.setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        
        UIView.animate(withDuration: self.duration, animations: {
            self.frame.origin.y = self.screenHeight - self.height - self.padding/2
        })
        perform(#selector(hide), with: self, afterDelay: self.delay)
    }
    
    @objc private func hide(_ alertView: UIButton) {
        
        UIView.animate(withDuration: duration, animations: {
            alertView.frame.origin.y = self.screenHeight
        })
        
        perform(#selector(remove), with: alertView, afterDelay: delay)
    }
    
    
    @objc private func addWindowSubview(_ view: UIView) {
        if self.superview == nil {
            let frontToBackWindows = UIApplication.shared.windows.reversed()
            for window in frontToBackWindows {
                if window.windowLevel == UIWindow.Level.normal
                    && !window.isHidden
                    && window.frame != CGRect.zero {
                    window.addSubview(view)
                    return
                }
            }
        }
    }
    
    @objc private func remove(_ alertView: UIButton) {
        alertView.removeFromSuperview()
    }
    
    // MARK: Interface
    
    public func alertWith(_ title: String,
                          backgroundColor: UIColor = UIColor.lightBlack) {
        self.delay = 3.0
        show(title, backgroundColor: backgroundColor)
    }
    
    
}

extension UIColor {
    public static var lightBlack: UIColor {
        return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8)
    }
}
