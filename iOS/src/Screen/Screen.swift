//
//  Screen.swift
//  iOS
//
//  Created by R on 30.09.2019.
//  Copyright © 2019 R. All rights reserved.
//

import UIKit

final public class Screen: UIViewController {

    public typealias OrientationResult = (_ orientation: UIDeviceOrientation) -> Void
    
    private var name: String?
    private var mainView: UIView?
    private var orientation: OrientationResult?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    // MARL: - Builder
    
    @discardableResult
    public func name(_ name: String?) -> Self {
        self.name = name
        return self
    }
    
    @discardableResult
    public func view(_ view: UIView?) -> Self {
        self.mainView = view
        return self
    }
    
    @discardableResult
    public func title(_ title: String?) -> Self {
        self.title = title
        return self
    }
    
    @discardableResult
    public func leftButton(_ button: Button?) -> Self {
        return self
    }

    @discardableResult
    public func rightButton(_ button: Button?) -> Self {
        return self
    }

    @discardableResult
    public func leftButtons(_ buttons: [Button]) -> Self {
        return self
    }

    @discardableResult
    public func rightButtons(_ buttons: [Button]) -> Self {
        return self
    }

    @discardableResult
    public func background(_ image: UIImage?) -> Self {
        return self
    }

    @discardableResult
    public func backgroundColor(_ color: UIColor?) -> Self {
        view.backgroundColor = color
        return self
    }
    
    @discardableResult
    public func backButton(_ button: Button?) -> Self {
        return self
    }
    
    @discardableResult
    public func orientation(_ orientation: OrientationResult?) -> Self {
        self.orientation = orientation
        return self
    }
    
    @discardableResult
    public func color(_ color: UIColor?) -> Self {
        if let vc = navigationController as? NavigationScreen {
            vc.color(color)
        }
        return self
    }
    
    @discardableResult
    public func buttonColor(_ color: UIColor?) -> Self {
        if let vc = navigationController as? NavigationScreen {
            vc.buttonColor(color)
        }
        return self
    }
    
    @discardableResult
    public func titleColor(_ color: UIColor?) -> Self {
        if let vc = navigationController as? NavigationScreen {
            vc.titleColor(color)
        }
        return self
    }
    
    @discardableResult
    public func tint(_ color: UIColor?) -> Self {
        if let vc = navigationController as? NavigationScreen {
            vc.tint(color)
        }
        return self
    }
    
    @discardableResult
    @available(iOS 11.0, *)
    public func largeTitle(_ largeTitle: Bool) -> Self {
        if let vc = navigationController as? NavigationScreen {
            vc.largeTitle(largeTitle)
        }
        return self
    }
    
    @discardableResult
    public func titleAttributes(_ titleAttributes: [NSAttributedString.Key : Any]?) -> Self {
        if let vc = navigationController as? NavigationScreen {
            vc.titleAttributes(titleAttributes)
        }
        return self
    }
    
    @discardableResult
    @available(iOS 11.0, *)
    public func largeTitleAttributes(_ largeTitleAttributes: [NSAttributedString.Key : Any]?) -> Self {
        if let vc = navigationController as? NavigationScreen {
            vc.largeTitleAttributes(largeTitleAttributes)
        }
        return self
    }
    
    // MARK: - Getter
    
    public static func name(_ name: String) -> UIViewController? {
        return nil
    }
    
    // MARK: - Orientation
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        orientation?(UIDevice.current.orientation)
    }
}

