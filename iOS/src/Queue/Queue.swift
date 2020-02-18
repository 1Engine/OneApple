//
//  Thread.swift
//  r-ios
//
//  Created by R on 07.08.2019.
//  Copyright © 2019 R. All rights reserved.
//

import UIKit

final public class Queue {
    
    public enum Group {
        case main
        case new
        case background
        case priority(DispatchQoS.QoSClass)
        case custom(DispatchQueue, Bool)
    }
    
    public typealias Execute = @convention(block) () -> Void
    
    public static func main(_ execute: @escaping Execute) {
        run(.main, execute: execute)
    }

    public static func new(_ execute: @escaping Execute) {
        run(.new, execute: execute)
    }

    public static func background(_ execute: @escaping Execute) {
        run(.background, execute: execute)
    }
    
    public static func run(_ group: Group = .new, execute: @escaping Execute) {
        switch group {
        case .main:
            DispatchQueue.main.async(execute: execute)
        case .new:
            DispatchQueue.global(qos: .userInitiated).async(execute: execute)
        case .background:
            DispatchQueue.global(qos: .background).async(execute: execute)
        case .priority(let priority):
            DispatchQueue.global(qos: priority).async(execute: execute)
        case .custom(let queue, let async):
            if async {
                queue.async(execute: execute)
            } else {
                queue.sync(execute: execute)
            }
        }
    }

}
