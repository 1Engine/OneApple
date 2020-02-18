//
//  Network.swift
//  iOS
//
//  Created by R on 19.11.2019.
//  Copyright © 2019 R. All rights reserved.
//

import Foundation
import Reachability
import SystemConfiguration.CaptiveNetwork

final public class Network {

    public static var isWifi: Bool {
        return Reachability.forInternetConnection().isReachableViaWiFi()
    }
    
    public static var isConnected: Bool {
        return Reachability.forInternetConnection().isReachable()
    }
    
    public static var wifiName: String? {
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    return interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                }
            }
        }
        return nil
    }
}
