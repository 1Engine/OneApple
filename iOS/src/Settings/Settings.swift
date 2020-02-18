//
//  rSettings.swift
//  r-ios
//
//  Created by R on 05.08.2019.
//  Copyright © 2019 R. All rights reserved.
//

import UIKit

open class Settings {

    public static func set(_ variable: Any?, for key: String, persistent: Bool = false) {
        Storage.set(variable, for: key, persistent: persistent)
    }
    
    public static func get<T: Decodable>(_ key: String, persistent: Bool = false) -> T? {
        return Storage.get(key, persistent: persistent)
    }
    
    public static func get<T>(file: String) -> T? {
        return Storage.get(file: file)
    }
    
    public static func set(_ content: Any?, file: String) {
        Storage.set(content, file: file)
    }
}
