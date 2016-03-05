//
//  MLocation.swift
//  EndingViolence
//
//  Created by Paul Wadsworth on 05/03/2016.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import RealmSwift
import CoreLocation

class MLocation: Object {
    
    var rLocation: CLLocation {
        set {
            _rLatitude = rLocation.coordinate.latitude
            _rLongitude = rLocation.coordinate.longitude
            _rTimeStamp = rLocation.timestamp
        }
        get {
            return CLLocation(
                coordinate: CLLocationCoordinate2D(latitude: _rLatitude, longitude: _rLongitude),
                altitude: 0,
                horizontalAccuracy: 0,
                verticalAccuracy: 0,
                timestamp: _rTimeStamp
            )
        }
    }
    
    dynamic var _rTimeStamp = NSDate()
    dynamic var _rLatitude: Double = 0
    dynamic var _rLongitude: Double = 0
    
    override class func ignoredProperties() -> [String] {
        return ["rLocation"]
    }
    
}


