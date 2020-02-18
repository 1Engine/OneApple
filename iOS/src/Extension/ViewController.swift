//
//  ViewController.swift
//  iOS
//
//  Created by R on 30.09.2019.
//  Copyright © 2019 R. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    static var root: UIViewController? {
        return UIApplication.shared.delegate?.window??.rootViewController
    }
    static var top: UIViewController? {
        return top()
    }

    func push(animated: Bool = true) {
        if let vc = UIViewController.top {
            if let vc = vc as? UINavigationController {
                vc.pushViewController(self, animated: animated)
            } else {
                vc.navigationController?.pushViewController(vc, animated: animated)
            }
        } else {
            let vc = UINavigationController()
            vc.viewControllers = [self]
            vc.root()
        }
    }

    func root() {
        UIApplication.shared.delegate?.window??.rootViewController = self
    }
    
    func first() {
        if let vc = UIViewController.top as? UINavigationController {
            vc.viewControllers = [self]
        }
    }
    
    static func top(from viewController: UIViewController? = root) -> UIViewController? {
        if let navigationController = viewController as? UINavigationController {
            return top(from: navigationController.visibleViewController) ?? navigationController
        } else if let presentedViewController = viewController?.presentedViewController {
            return top(from: presentedViewController)
        } else {
            return viewController
        }
    }

    static func endEditing(_ force: Bool = true) {
        top?.view.endEditing(force)
    }
}

public extension String {
    
    var screen: UIViewController {
        return UIStoryboard(name: "Screen", bundle: Bundle(for: Application.classForCoder())).instantiateViewController(withIdentifier: self)
    }
}
