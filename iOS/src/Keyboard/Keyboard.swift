//
//  Keyboard.swift
//  iOS
//
//  Created by R on 08.10.2019.
//  Copyright © 2019 R. All rights reserved.
//

import UIKit

final public class Keyboard: UIView {

    public static var isEnabled = false
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public convenience init(on input: UITextInput) {
        self.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
