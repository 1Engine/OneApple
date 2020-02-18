//
//  Application.swift
//  r-ios
//
//  Created by R on 05.08.2019.
//  Copyright © 2019 R. All rights reserved.
//

import UIKit

open class Application: UIResponder, UIApplicationDelegate {
    
    open var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    
    open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.delegate?.window??.rootViewController = NavigationScreen()
        UIApplication.shared.delegate?.window??.makeKeyAndVisible()
        start()
        return true
    }
    
    open func start() {}
}
