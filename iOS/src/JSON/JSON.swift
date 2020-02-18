//
//  JSON.swift
//  iOS
//
//  Created by R on 08.10.2019.
//  Copyright © 2019 R. All rights reserved.
//

import Foundation

final public class JSON {

    public static func encode<T: Encodable>(object: T, options: JSONEncoder.OutputFormatting = []) -> Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = options
        return try? encoder.encode(object)
    }

    public static func encode(object: Any, options: JSONSerialization.WritingOptions = []) -> Data? {
        return try? JSONSerialization.data(withJSONObject: object, options: options)
    }
    
    public static func decode<T: Decodable>(_ type: T.Type, data: Data) -> T? {
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
    
    public static func decode(data: Data, options: JSONSerialization.ReadingOptions = []) -> Any?  {
        return try? JSONSerialization.jsonObject(with: data, options: options)
    }
    
}

extension Encodable {
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
}
