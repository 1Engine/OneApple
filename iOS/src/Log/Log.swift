//
//  Log.swift
//  iOS
//
//  Created by R on 01.10.2019.
//  Copyright © 2019 R. All rights reserved.
//

import Foundation

final public class Log {

    public static var maxLength = 200
    
    public static func debug(_ tag: String, _ message: String) {
        #if DEBUG
        let message = message.count > maxLength ? String(message.prefix(maxLength)) + "\n..." : message
        print(tag + " : " + message)
        #endif
    }
    
    public static func debug(_ tag: String, _ error: Error?) {
        debug(tag, error?.localizedDescription ?? "error")
    }
}
