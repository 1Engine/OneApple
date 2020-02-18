//
//  Storage.swift
//  r-ios
//
//  Created by R on 05.08.2019.
//  Copyright © 2019 R. All rights reserved.
//

import Foundation

final public class Storage {

    public static func set(_ variable: Any?, for key: String, persistent: Bool = false) {
        if !persistent {
            if variable == nil {
                UserDefaults.standard.removeObject(forKey: key)
            } else {
                if let object = variable as? Encodable {
                    UserDefaults.standard.set(object.json, forKey: key)
                }
            }
        } else {
            if variable == nil {
                let query: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword as String,
                    kSecAttrAccount as String: key]
                SecItemDelete(query as CFDictionary)
            } else if let object = variable as? Encodable,
                let data = object.json {
                let query: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword as String,
                    kSecAttrAccount as String: key,
                    kSecValueData as String: data]
                SecItemDelete(query as CFDictionary)
                SecItemAdd(query as CFDictionary, nil)
            }
        }
    }
    
    public static func get<T: Decodable>(_ key: String, persistent: Bool = false) -> T? {
        if !persistent {
            guard let data = UserDefaults.standard.data(forKey: key) else {
                return nil
            }
            return try? JSONDecoder().decode(T.self, from: data)
        }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne]
        var dataTypeRef: AnyObject? = nil
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == noErr,
            let data = dataTypeRef as! Data? {
            return try? JSONDecoder().decode(T.self, from: data)
        } else {
            return nil
        }
    }
    
    public static func get<T>(file: String) -> T? {
        return nil
    }
    
    public static func set(_ content: Any?, file: String) {
        
    }
}
