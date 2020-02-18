
//
//  Wait.swift
//  r-ios
//
//  Created by R on 05.08.2019.
//  Copyright © 2019 R. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

final public class Wait {

    private(set) public static var isWait: Bool = false
    public static var size: CGSize = CGSize(width: 100, height: 100)
    public static var font: UIFont = UIFont.systemFont(ofSize: 16)
    public static var color: UIColor = .darkGray
    public static var backgroundColor: UIColor = .white
    public static var textColor: UIColor = .darkGray
    public static var minDisplayTime: TimeInterval = 0
    public static var thresholdTime: TimeInterval = 0.5
    public static var type: NVActivityIndicatorType = .circleStrokeSpin

    public static var delayInterval: TimeInterval = 0.3
    public static var delayLongInterval: TimeInterval = 1
    
    // MARK: - Delay
    
    public static func delay(_ duration: Double = delayInterval, isMainThread: Bool = true, execute: @escaping @convention(block) () -> Void) {
        if isMainThread {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: execute)
        } else {
            DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + duration, execute: execute)
        }
    }
    
    public static func delay(_ duration: Double = delayInterval, queue: DispatchQueue, execute: @escaping @convention(block) () -> Void) {
        queue.asyncAfter(deadline: .now() + duration, execute: execute)
    }
    
    public static func longDelay(isMainThread: Bool = true, execute: @escaping @convention(block) () -> Void) {
        delay(delayLongInterval, isMainThread: isMainThread, execute: execute)
    }
    
    // MARK: - Show & Hide
    
    public static func show(with message: String? = nil, isThresholdTime: Bool = false) {
        if isWait {
            return
        }
        UIViewController.top?.view.endEditing(true)
        isWait = true
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(
            size: size,
            message: message,
            messageFont: font,
            type: type,
            color: color,
            padding: nil,
            displayTimeThreshold: isThresholdTime ? Int(thresholdTime * 1000) : nil,
            minimumDisplayTime: Int(minDisplayTime * 1000),
            backgroundColor: backgroundColor,
            textColor: textColor), nil)
    }
    
    public static func update(message: String?) {
        if isWait {
            NVActivityIndicatorPresenter.sharedInstance.setMessage(message)
        }
    }
    
    public static func hide() {
        isWait = false
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
        // repeat again
        delay(0.3) {
            if !isWait {
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            }
        }
    }
    
    // MARK: - Builder
    
    @discardableResult
    public func show(_ message: String? = nil) -> Self {
        Wait.show(with: message)
        return self
    }
    
    @discardableResult
    public func hide() -> Self {
        Wait.hide()
        return self
    }

}
