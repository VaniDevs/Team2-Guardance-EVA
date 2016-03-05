//
//  LocationMgr.swift
//  EndingViolence
//
//  Created by Paul Wadsworth on 05/03/2016.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import Foundation

//
//  LocationManager.swift
//  CoreLocationPlayground
//
//  Created by Paul Wadsworth on 08/10/2015.
//  Copyright © 2015 TapDigital Canada Inc. All rights reserved.
//

import Foundation
import CoreLocation

public extension CLAuthorizationStatus {
    
    public var toString: String {
        switch self {
        case .NotDetermined:       return "NotDetermined"
        case .Restricted:          return "Restricted"
        case .Denied:              return "Denied"
        case .AuthorizedAlways:    return "AuthorizedAlways"
        case .AuthorizedWhenInUse: return "AuthorizedWhenInUse"
        }
    }
}

public enum TKAuthorizationType {
    case Always
    case WhenInUse
}

public enum TKLocationAccuracy {
    case BestForNavigation, Best, NearestTenMeters, HundredMeters, Kilometer, ThreeKilometers
    
    private var clLocationAccuracy: CLLocationAccuracy {
        switch self {
        case .BestForNavigation: return kCLLocationAccuracyBestForNavigation
        case .Best: return kCLLocationAccuracyBest
        case .NearestTenMeters: return kCLLocationAccuracyNearestTenMeters
        case .HundredMeters: return kCLLocationAccuracyHundredMeters
        case .Kilometer: return kCLLocationAccuracyKilometer
        case .ThreeKilometers: return kCLLocationAccuracyThreeKilometers
        }
    }
}

public class TKLocationManager : NSObject {
    
    public typealias LocationManagerUpdateCallback = (CLLocation) -> ()
    
    public init(accuracy: TKLocationAccuracy, authorizationType: TKAuthorizationType = .WhenInUse) {
        
        self.authorizationType = authorizationType
        super.init()
        
        locationManager.desiredAccuracy = accuracy.clLocationAccuracy
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        locationEnabled = isEnabled(CLLocationManager.authorizationStatus())
        
        locationManager.delegate = self
    }
    
    public func start(updateCallback: LocationManagerUpdateCallback? = nil) {
        if locationEnabled {
            self.updateCallback = updateCallback
            if let location = lastLocation {
                updateCallback?(location)
            }
            locationManager.startMonitoringSignificantLocationChanges()
        }
    }
    
    public func stop() {
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    public dynamic private(set) var locationEnabled = true // KVO
    
    public var lastLocation: CLLocation? {
        return locationManager.location
    }
    
    private var updateCallback: LocationManagerUpdateCallback?
    
    private let authorizationType: TKAuthorizationType
    
    private let locationManager = CLLocationManager()
    
    private func isEnabled(status: CLAuthorizationStatus) -> Bool {
        
        switch status {
        case .NotDetermined:
            
            switch authorizationType { // Does nothing if called for any other state
            case .Always:
                locationManager.requestAlwaysAuthorization()
            case .WhenInUse:
                locationManager.requestWhenInUseAuthorization()
            }
            
            return false
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            return true
        case .Denied, .Restricted:
            return false
        }
    }
}

extension TKLocationManager : CLLocationManagerDelegate {
    
    // Called when app is first run
    // Called the app's permissions are changed from Settings (app is in background) when it returns to the foreground
    public func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        locationEnabled = isEnabled(status)
    }
    
    public func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            updateCallback?(location)
        }
    }
    
    public func locationManagerDidPauseLocationUpdates(manager: CLLocationManager) {
        print(self, __FUNCTION__)
    }
    
    public func locationManagerDidResumeLocationUpdates(manager: CLLocationManager) {
        print(self, __FUNCTION__)
    }
}