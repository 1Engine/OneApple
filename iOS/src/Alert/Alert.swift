//
//  Alert.swift
//  r-ios
//
//  Created by R on 05.08.2019.
//  Copyright © 2019 R. All rights reserved.
//

import UIKit
import AVFoundation

extension UIAlertController {
    
    private struct Store {
        static var blurStyle = "UIAlertController.blurStyleKey"
    }
    
    static var cancelButtonColor: UIColor?
    
    private var blurStyle: UIBlurEffect.Style {
        get {
            return objc_getAssociatedObject(self, &Store.blurStyle) as? UIBlurEffect.Style ?? .extraLight
        }
        set (style) {
            objc_setAssociatedObject(self, &Store.blurStyle, style, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
    
    private var cancelButtonColor: UIColor? {
        return blurStyle == .dark ? UIAlertController.cancelButtonColor : nil
    }
    
    private var visualEffectView: UIVisualEffectView? {
        if let presentationController = presentationController,
            presentationController.responds(to: Selector(("popoverView"))),
            let view = presentationController.value(forKey: "popoverView") as? UIView
        {
            // iPad
            return view.flatSubviews.compactMap {$0 as? UIVisualEffectView} .first
        }
        return view.flatSubviews.compactMap {$0 as? UIVisualEffectView} .first
    }
    
    private var cancelActionView: UIView? {
        return view.flatSubviews.compactMap {
            $0 as? UILabel
            }.first(where: {
                $0.text == actions.first(where: { $0.style == .cancel })?.title
            })?.superview?.superview
    }
    
    convenience init(title: String?, message: String?, preferredStyle: UIAlertController.Style, blurStyle: UIBlurEffect.Style) {
        self.init(title: title, message: message, preferredStyle: preferredStyle)
        self.blurStyle = blurStyle
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        visualEffectView?.effect = UIBlurEffect(style: blurStyle)
        cancelActionView?.backgroundColor = cancelButtonColor
    }
}

final public class Alert {
    
    private static var alert: UIAlertController?
    
    public static var isAlert: Bool {
        get {
            return UIViewController.top is UIAlertController
        }
    }
    
    public static func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        alert?.dismiss(animated: animated, completion: completion)
    }
    
    public init() {}
    
    // MARK: - OK
    
    public static func ok(
        _ title: String,
        message: String? = nil,
        isSay: Bool? = true,
        button: Button? = nil,
        on present: UIViewController? = nil) {
        
        if isSay == true
            || AI.isSayEvents {
            AI.say(message ?? title)
        }
        
        alert = UIAlertController(title: title.localized, message: message?.localized, preferredStyle: .alert, blurStyle: !Theme.isDark ? .extraLight : .dark)
        
        let action = UIAlertAction(title: (button?.title ?? "OK").localized, style: .cancel) { _ in
            button?.tap?()
        }
        action.setValue(UIColor.highlight, forKey: "titleTextColor")
        alert!.addAction(action)
        alert!.view.tintColor = UIColor.highlight
        
        if Theme.isDark {
            alert!.setValue(NSAttributedString(string: alert!.title!, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.sz, weight: .medium),
                NSAttributedString.Key.foregroundColor : UIColor.text
            ]), forKey: "attributedTitle")
            if alert!.message != nil {
                alert!.setValue(NSAttributedString(string: alert!.title!, attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.sz, weight: .regular),
                    NSAttributedString.Key.foregroundColor : UIColor.text
                ]), forKey: "attributedMessage")
            }
        }
        
        UIViewController.endEditing()
        
        if let viewController = present {
            viewController.present(alert!, animated: true, completion: nil)
        } else {
            UIViewController.top?.present(alert!, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - List
    
    public static func select(
        _ title: String,
        message: String? = nil,
        list: [String],
        cancel: Button? = nil,
        style: (_ index: Int, _ title: String) -> UIAlertAction.Style = { _,_ in return .default },
        on present: UIViewController? = nil,
        action: @escaping (_ index: Int, _ name: String) -> Void) {
        
        alert = UIAlertController(title: title.localized, message: message?.localized, preferredStyle: .actionSheet, blurStyle: !Theme.isDark ? .extraLight : .dark)
        
        for index in 0..<list.count {
            alert!.addAction(UIAlertAction(title: list[index].localized, style: style(index, list[index].localized), handler: { _ in
                action(index, list[index])
            }))
        }
        alert!.addAction(UIAlertAction(title: (cancel?.title == nil ? "Cancel" : cancel!.title!).localized, style: UIAlertAction.Style.cancel) { _ in
            cancel?.tap?()
        })
        alert!.view.tintColor = UIColor.highlight
        
        for action in alert!.actions {
            action.style == .default
                ?  action.setValue(UIColor.highlight, forKey: "titleTextColor")
                : ()
        }
        UIViewController.endEditing()
        
        if let view = (present == nil ? UIViewController.top?.view : present?.view) {
            alert!.popoverPresentationController?.sourceView = view
            alert!.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.size.width / 2.0, y: view.bounds.size.height - 20.sz, width: 1.0, height: 1.0)
        }
        
        if let viewController = present {
            viewController.present(alert!, animated: true, completion: nil)
        } else {
            UIViewController.top?.present(alert!, animated: true, completion: nil)
        }
    }
    
    // MARK: - Edit
    
    public static func edit(
        _ title: String,
        message: String? = nil,
        text: String? = nil,
        placeholder: String? = nil,
        keyboardType: UIKeyboardType = .default,
        isAutoselect: Bool = true,
        doneTitle: String,
        cancel: Button? = nil,
        on present: UIViewController? = nil,
        done: @escaping (_ text: String) -> Void) {
        
        alert = UIAlertController(title: title.localized, message: message?.localized, preferredStyle: .alert, blurStyle: !Theme.isDark ? .extraLight : .dark)
        
        if Theme.isDark {
            alert!.setValue(NSAttributedString(string: alert!.title!, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.sz, weight: .medium),
                NSAttributedString.Key.foregroundColor : UIColor.text
            ]), forKey: "attributedTitle")
            if alert!.message != nil {
                alert!.setValue(NSAttributedString(string: alert!.title!, attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.sz, weight: .regular),
                    NSAttributedString.Key.foregroundColor : UIColor.text
                ]), forKey: "attributedMessage")
            }
        }
        
        alert!.addTextField(configurationHandler: { textField in
            textField.text = text
            textField.placeholder = placeholder?.localized
            textField.keyboardType = keyboardType
            textField.backgroundColor = UIColor.background
            textField.textColor = UIColor.text
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholder])
            
            if text != nil
                && text!.count > 0
                && isAutoselect {
                Wait.longDelay {
                    textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
                }
            }
        })
        alert!.addAction(UIAlertAction(title: doneTitle.localized, style: .default, handler: { (action: UIAlertAction!) in
            done((alert!.textFields![0] as UITextField).text!)
        }))
        alert!.addAction(UIAlertAction(title: (cancel?.title == nil ? "Cancel" : cancel!.title!).localized, style: UIAlertAction.Style.cancel) { _ in
            cancel?.tap?()
        })
        alert!.view.tintColor = UIColor.highlight
        for action in alert!.actions {
            action.setValue(UIColor.highlight, forKey: "titleTextColor")
        }
        let textField = alert!.textFields![0]
        textField.font = UIFont.systemFont(ofSize: 18.sz)
        textField.textColor = UIColor.text
        if Keyboard.isEnabled {
            textField.inputView = Keyboard(on: textField)
        }
        UIViewController.endEditing()
        
        if let viewController = present {
            viewController.present(alert!, animated: true, completion: nil)
        } else {
            UIViewController.top?.present(alert!, animated: true, completion: nil)
        }
        
        textField.superview?.backgroundColor = .clear
        textField.superview?.layer.cornerRadius = 6
        textField.superview?.layer.borderColor = UIColor.border.cgColor
        textField.superview?.layer.borderWidth = 0.5
        textField.superview?.superview?.subviews[0].removeFromSuperview()
    }
    
    
    // MARK: - Dialog
    
    public static func dialog(
        _ title: String,
        message: String? = nil,
        isSay: Bool? = nil,
        button: Button,
        cancel: Button? = nil,
        on present: UIViewController? = nil) {
        
        dialog(title, message: message, isSay: isSay, buttons: [button], cancel: cancel, on: present)
    }
    
    public static func dialog(
        _ title: String,
        message: String? = nil,
        isList: Bool = false,
        isSay: Bool? = nil,
        buttons: [Button] = [],
        cancel: Button? = nil,
        on present: UIViewController? = nil) {
        
        if isSay == true
            || AI.isSayEvents {
            AI.say(title)
        }
        
        alert = UIAlertController(title: title.localized, message: message?.localized, preferredStyle: !isList ? .alert : .actionSheet, blurStyle: !Theme.isDark ? .extraLight : .dark)
        
        if !isList
            && Theme.isDark {
            alert!.setValue(NSAttributedString(string: alert!.title!, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.sz, weight: .medium),
                NSAttributedString.Key.foregroundColor : UIColor.text
            ]), forKey: "attributedTitle")
            if alert!.message != nil {
                alert!.setValue(NSAttributedString(string: alert!.title!, attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.sz, weight: .regular),
                    NSAttributedString.Key.foregroundColor: UIColor.text
                ]), forKey: "attributedMessage")
            }
        }
        
        alert!.view.tintColor = UIColor.highlight
        for index in 0..<buttons.count {
            alert!.addAction(UIAlertAction(title: buttons[index].title!.localized, style: .default, handler: { (action: UIAlertAction!) in
                buttons[index].tap?()
            }))
        }
        alert!.addAction(UIAlertAction(title: (cancel?.title == nil ? "Cancel" : cancel!.title!).localized, style: .cancel) { _ in
            cancel?.tap?()
        })
        for action in alert!.actions {
            action.setValue(UIColor.highlight, forKey: "titleTextColor")
        }
        UIViewController.endEditing()
        
        if let view = (present == nil ? UIViewController.top?.view : present?.view) {
            alert!.popoverPresentationController?.sourceView = view
            alert!.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.size.width / 2.0, y: view.bounds.size.height - 20.sz, width: 1.0, height: 1.0)
        }
        
        if let vc = present {
            vc.present(alert!, animated: true, completion: nil)
        } else {
            UIViewController.top?.present(alert!, animated: true, completion: nil)
        }
    }
    
    public enum PresentType {
        public enum Notification {
            case success
            case error
            case info
        }
        case list
        case dialog
        case edit
        case time
        case date
        case select
        case ok
        case notification(Notification)
    }
    
    private var type: PresentType = .ok
    private var title: String?
    private var text: String?
    private var buttons: [Button] = []
    private var cancel: Button?
    private var remove: Button?
    private var tap: (() -> Void)?
    
    // MARK: - Builder
    
    @discardableResult
    public func type(_ type: PresentType) -> Self {
        self.type = type
        return self
    }

    @discardableResult
    public func title(_ title: String?) -> Self {
        self.title = title
        return self
    }

    @discardableResult
    public func text(_ text: String?) -> Self {
        self.text = text
        return self
    }

    @discardableResult
    public func text(_ error: Error) -> Self {
        self.text = "\(error)"
        return self
    }

    @discardableResult
    public func buttons(_ buttons: [Button]) -> Self {
        self.buttons = buttons
        return self
    }

    @discardableResult
    public func cancel(_ cancel: Button?) -> Self {
        self.cancel = cancel
        return self
    }

    @discardableResult
    public func remove(_ remove: Button?) -> Self {
        self.remove = remove
        return self
    }

    @discardableResult
    public func tap(_ tap: (() -> Void)?) -> Self {
        self.tap = tap
        return self
    }
    
    @discardableResult
    public func show() -> Self {
        switch type {
        case .list: break
        case .dialog: break
        case .edit: break
        case .time: break
        case .date: break
        case .select: break
        case .ok: break
        case .notification(let type):
            print("\(type)")
        }
        return self
    }
    
}
