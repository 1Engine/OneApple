//
//  SliderView.swift
//  r-ios
//
//  Created by R on 05.08.2019.
//  Copyright © 2019 R. All rights reserved.
//

import UIKit

final public class SliderView: UISlider {

    private var name: String?
    private var width: CGFloat?
    private var height: CGFloat?
    private var position: Position?

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
    
}
