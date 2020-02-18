//
//  Location.swift
//  r-ios
//
//  Created by R on 05.08.2019.
//  Copyright © 2019 R. All rights reserved.
//

import Foundation
import CoreLocation

final public class Location: NSObject {

    public enum AuthorizationType {
        case always
        case inUse
    }
    public static var authorizationType: AuthorizationType = .always
    private static let manager = CLLocationManager()
    private static let location: Location = {
        return Location()
    }()
    public static var isNotification = false
    
    public typealias Result = (_ location: CLLocation?, _ heading: CLHeading?) -> Void
    
    private static var subscribers: [String: Result] = [:]
    
    public static func change(_ tag: String, result: @escaping Result) {
        subscribers[tag] = result
    }
    
    public static func remove(_ tag: String) {
        subscribers.removeValue(forKey: tag)
    }
    
    public static func start() {
        manager.delegate = location
        switch authorizationType {
        case .always:
            manager.requestAlwaysAuthorization()
        case .inUse:
            manager.requestWhenInUseAuthorization()
        }
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
    }
    
    public static func stop() {
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
    }
}

extension Location: CLLocationManagerDelegate {
 
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Location.subscribers.values.forEach { result in
            result(manager.location, manager.heading)
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        Location.subscribers.values.forEach { result in
            result(manager.location, manager.heading)
        }
    }
    
    public func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }

    public func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
    }

    public func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    public func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        
    }
    
    public func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        
    }
    
    public func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        
    }
    
    public func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        
    }
}
