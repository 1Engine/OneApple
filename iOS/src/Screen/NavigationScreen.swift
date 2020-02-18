//
//  NavigationScreen.swift
//  r-ios
//
//  Created by R on 05.08.2019.
//  Copyright © 2019 R. All rights reserved.
//

import UIKit

final public class NavigationScreen: UINavigationController {

    private var name: String?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Builder

    @discardableResult
    public func name(_ name: String?) -> Self {
        self.name = name
        return self
    }

    @discardableResult
    public func color(_ color: UIColor?) -> Self {
        buttonColor(color)
        titleColor(color)
        return self
    }

    @discardableResult
    public func buttonColor(_ color: UIColor?) -> Self {
        navigationBar.tintColor = color
        return self
    }
    
    @discardableResult
    public func titleColor(_ color: UIColor?) -> Self {
        if let color = color {
            if navigationBar.titleTextAttributes == nil {
                navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
            } else {
                navigationBar.titleTextAttributes?[NSAttributedString.Key.foregroundColor] = color
            }
            if #available(iOS 11.0, *) {
                if navigationBar.largeTitleTextAttributes == nil {
                    navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
                } else {
                    navigationBar.largeTitleTextAttributes?[NSAttributedString.Key.foregroundColor] = color
                }
            }
        } else {
            navigationBar.titleTextAttributes?.removeValue(forKey: NSAttributedString.Key.foregroundColor)
            if #available(iOS 11.0, *) {
                navigationBar.largeTitleTextAttributes?.removeValue(forKey: NSAttributedString.Key.foregroundColor)
            }
        }
        return self
    }
    
    @discardableResult
    public func tint(_ color: UIColor?) -> Self {
        navigationBar.barTintColor = color
        return self
    }

    @discardableResult
    @available(iOS 11.0, *)
    public func largeTitle(_ largeTitle: Bool) -> Self {
        navigationBar.prefersLargeTitles = largeTitle
        return self
    }

    @discardableResult
    public func titleAttributes(_ titleAttributes: [NSAttributedString.Key : Any]?) -> Self {
        navigationBar.titleTextAttributes = titleAttributes
        return self
    }

    @discardableResult
    @available(iOS 11.0, *)
    public func largeTitleAttributes(_ largeTitleAttributes: [NSAttributedString.Key : Any]?) -> Self {
        navigationBar.largeTitleTextAttributes = largeTitleAttributes
        return self
    }

}
