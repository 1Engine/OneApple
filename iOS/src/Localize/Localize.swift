//
//  Localize.swift
//  iOS
//
//  Created by R on 08.10.2019.
//  Copyright © 2019 R. All rights reserved.
//

import UIKit

final public class Localize {

    public static var locale: Locale {
        return Locale.current
    }

    public static var language: String {
        return Locale.current.scriptCode ?? ""
    }
    
    public static var systemLanguage: String {
        return Locale.preferredLanguages[0]
    }

    public static var preferredLanguages: [String] {
        return Locale.preferredLanguages
    }

}
