//
//  StickView.swift
//  iOS
//
//  Created by R on 03.12.2019.
//  Copyright © 2019 R. All rights reserved.
//

import UIKit

final public class StickView: UIView {

    public enum AnimationType {
        case none
        case height
        case width
        case fade
    }
    
    /*
     override func draw(_ rect: CGRect) {
     }*/
    
    private var name: String?
    private var views: [UIView] = []
    private var width: CGFloat?
    private var height: CGFloat?
    private var position: Position?
    
    // MARK: - Builder
    
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
    public func views(_ views: [UIView]) -> Self {
        self.views = views
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
    
    // MARK: - Getter
    
    public static func name(_ name: String) -> UIView? {
        return nil
    }
    
    // MARK: - Action
    
    @discardableResult
    public func hide(_ type: View.AnimationType = .none) -> Self {
        return self
    }
    
    @discardableResult
    public func show(_ type: View.AnimationType = .none) -> Self {
        return self
    }
}
