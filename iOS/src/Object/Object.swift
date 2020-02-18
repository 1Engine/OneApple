//
//  Object.swift
//  iOS
//
//  Created by R on 30.09.2019.
//  Copyright © 2019 R. All rights reserved.
//

import UIKit

public enum Direction {
    case horizontal
    case vertical
}

final public class Position {
    
    var top: CGFloat?
    var bottom: CGFloat?
    var left: CGFloat?
    var right: CGFloat?
    
    public init() {}

    public func top(_ top: CGFloat?) -> Position {
        self.top = top
        return self
    }

    public func bottom(_ bottom: CGFloat?) -> Position {
        self.bottom = bottom
        return self
    }

    public func left(_ left: CGFloat?) -> Position {
        self.left = left
        return self
    }

    public func right(_ right: CGFloat?) -> Position {
        self.right = right
        return self
    }
}

final public class Style {
    
    var color: UIColor?
    var background: UIColor?
    var borderWidth: CGFloat?
    var borderColor: UIColor?
    var margin: Position?
    var tapColor: UIColor?
    var tapBackgroundColor: UIColor?
    var tapScale: CGFloat?
    
    public init() {}
    
    @discardableResult
    public func background(_ background: UIColor) -> Self {
        self.background = background
        return self
    }

}

final public class Badge {
    
    var title: String?
    var color: UIColor?
    var background: UIColor?
    var image: UIImage?
}

final public class Button {

    var name: String?
    var title: String?
    var image: UIImage?
    var tint: UIColor?
    var badge: Badge?
    var style: Style?
    var enabled = true
    var hidden = false
    var tap: (() -> Void)?
    
    public init(_ name: String? = nil) {
        self.name = name
    }

    @discardableResult
    public func name(_ name: String) -> Self {
        self.name = name
        return self
    }

    @discardableResult
    public func title(_ title: String?) -> Self {
        self.title = title
        return self
    }

    @discardableResult
    public func image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }

    @discardableResult
    public func image(_ image: String?) -> Self {
        self.image = image?.image
        return self
    }

    @discardableResult
    public func tint(_ tint: UIColor?) -> Self {
        self.tint = tint
        return self
    }

    @discardableResult
    public func badge(_ badge: Badge?) -> Self {
        self.name = name
        return self
    }

    @discardableResult
    public func style(_ style: Style?) -> Self {
        self.style = style
        return self
    }

    @discardableResult
    public func enabled(_ enabled: Bool) -> Self {
        self.enabled = enabled
        return self
    }

    @discardableResult
    public func hidden(_ hidden: Bool) -> Self {
        self.hidden = hidden
        return self
    }

    @discardableResult
    public func tap(_ tap: (() -> Void)?) -> Self {
        self.tap = tap
        return self
    }
}
