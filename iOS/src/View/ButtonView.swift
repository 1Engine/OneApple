//
//  ButtonView.swift
//  r-ios
//
//  Created by R on 05.08.2019.
//  Copyright © 2019 R. All rights reserved.
//

import UIKit

final public class ButtonView: UIButton {

    private var name: String?
    private var title: String?
    private var image: UIImage?
    private var tint: UIColor?
    private var badge: Badge?
    private var style: Style?
    private var width: CGFloat?
    private var height: CGFloat?
    private var position: Position?

    private var tap: (() -> Void)?
    
    public init(_ name: String? = nil) {
        super.init(frame: .zero)
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
    public func width(_ width: CGFloat?) -> Self {
        self.width = width
        return self
    }
    
    @discardableResult
    public func height(_ height: CGFloat?) -> Self {
        self.height = height
        return self
    }
    
    @discardableResult
    public func position(_ position: Position?) -> Self {
        self.position = position
        return self
    }
    
    @discardableResult
    public func enabled(_ enabled: Bool) -> Self {
        self.isEnabled = enabled
        return self
    }
    
    @discardableResult
    public func hidden(_ hidden: Bool) -> Self {
        self.isHidden = hidden
        return self
    }
    
    @discardableResult
    public func tap(_ tap: (() -> Void)?) -> Self {
        self.tap = tap
        return self
    }
}
