//
//  Theme.swift
//  iOS
//
//  Created by R on 08.10.2019.
//  Copyright © 2019 R. All rights reserved.
//

import UIKit

final public class Theme {

    public static var isDark: Bool = false
    public static var scale: CGFloat = 1
}

public extension UIColor {
    
    static var highlight: UIColor = .blue
    static var text: UIColor = .darkGray
    static var background: UIColor = .white
    static var placeholder: UIColor = .lightGray
    static var border: UIColor = .lightGray
}
