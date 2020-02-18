//
//  WebView.swift
//  r-ios
//
//  Created by R on 05.08.2019.
//  Copyright © 2019 R. All rights reserved.
//

import UIKit
import WebKit

final public class WebView: WKWebView {

    private var name: String?
    private var width: CGFloat?
    private var height: CGFloat?
    private var position: Position?

    public init(_ name: String? = nil) {
        super.init(frame: .zero, configuration: WKWebViewConfiguration())
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
    public func url(_ url: String?) -> Self {
        return self
    }

    @discardableResult
    public func start(_ start: (() -> Void)?) -> Self {
        return self
    }

    @discardableResult
    public func end(_ end: (() -> Void)?) -> Self {
        return self
    }

    @discardableResult
    public func progress(_ progress: ((Double) -> Void)?) -> Self {
        return self
    }

    @discardableResult
    public func error(_ error: ((Error) -> Void)?) -> Self {
        return self
    }

    
}
