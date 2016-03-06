//
//  LocationManager.swift
//  EndingViolence
//
//  Created by Kaitlyn Melton on 2016-03-05.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//
//

import Foundation
import CoreLocation

class CoreLocationController : NSObject {

    var locationManager:CLLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
    }
    
    func start() {
        locationManager.startUpdatingLocation()
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
    }
    
    func requestLocation() -> CLLocation {
        print("Location returned")
        return locationManager.location!
    }
}

extension CoreLocationController : CLLocationManagerDelegate {
    // delegate
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus")
        
        switch status {
        case .NotDetermined:
            print(".NotDetermined")
            self.locationManager.requestAlwaysAuthorization()
            break
            
        case .Authorized:
            print(".Authorized")
            self.locationManager.startUpdatingLocation()
            break
            
        case .Denied, .Restricted:
            print(".Denied")
            self.locationManager.requestAlwaysAuthorization()
            break
            
        default:
            print("Unhandled authorization status")
            break
            
        }
    }
    
    // delegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // called when the requestion location has been determined
        
        let location = locations.last
        // requestLocation()
        print("didUpdateLocations:  \(location!.coordinate.latitude), \(location!.coordinate.longitude)")
        
    }

}
