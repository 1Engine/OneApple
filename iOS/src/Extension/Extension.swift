//
//  String.swift
//  iOS
//
//  Created by R on 08.10.2019.
//  Copyright © 2019 R. All rights reserved.
//

import UIKit

// MARK: - Localization

public extension String {
    
    var localized: String {
        return self
    }
}

// MARK: - Convertion

public extension Data {
    
    var string: String {
        return String(data: self, encoding: .utf8) ?? ""
    }
    
    func string(_ encoding: String.Encoding) -> String? {
        return String(data: self, encoding: encoding)
    }
}

// MARK: - View

public extension UIView {
    
    var flatSubviews: [UIView] {
        var subviews = self.subviews.compactMap { $0 }
        subviews.forEach {
            subviews.append(contentsOf: $0.flatSubviews)
        }
        return subviews
    }
}

// MARK: - Size-independent pixels

public extension Int {
    
    var sz: CGFloat {
        return CGFloat(self).sz
    }
}

public extension Float {
    
    var sz: CGFloat {
        return CGFloat(self).sz
    }
}

public extension CGFloat {
    
    var sz: CGFloat {
        return self * Theme.scale
    }
}

// MARK: - Image

public extension String {
    
    var image: UIImage? {
        return UIImage(named: self) ?? UIImage(named: self, in: Bundle(for: Application.classForCoder()), compatibleWith: nil)
    }
}

// MARK: - Color

public extension UIColor {
    static let smokieLightBlue        = UIColor(red:0.60, green:0.80, blue:1.00, alpha:1.0)
    static let extraLightBlue         = UIColor(red:0.92, green:0.96, blue:1.00, alpha:1.0)
    static let lightBlue              = UIColor(red:0.73, green:0.85, blue:0.93, alpha:1.0)
    static let darkBlue               = UIColor(red:0.25, green:0.37, blue:0.53, alpha:1.0)
    static let darkRed                = UIColor(red:0.65, green:0.21, blue:0.02, alpha:1.0)
    static let readyColor             = UIColor(red:0.80, green:1.00, blue:0.60, alpha:1.0)
    static let lightGreen             = UIColor(red:0.87, green:1.00, blue:0.85, alpha:1.0)
    static let extraLightYellow       = UIColor(red:1.00, green:1.00, blue:0.60, alpha:1.0)
    static let lightYellow            = UIColor(red:1.00, green:0.99, blue:0.77, alpha:1.0)
    static let lightOrange            = UIColor(red:1.00, green:0.80, blue:0.60, alpha:1.0)
    static let lightRed               = UIColor(red:1.00, green:0.91, blue:0.91, alpha:1.0)
    static let darkYellow             = UIColor(red:1.00, green:0.76, blue:0.00, alpha:1.0)
    static let darkGreen              = UIColor(red:0.03, green:0.77, blue:0.02, alpha:1.0)
    static let beige                  = UIColor(red:1.00, green:0.88, blue:0.67, alpha:1.0)
}

// MARK: - Array

public extension Array {
    
    func when(_ condition: Bool) -> Array {
        return condition ? self : []
    }
}
