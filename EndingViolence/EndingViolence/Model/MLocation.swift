//
//  MLocation.swift
//  EndingViolence
//
//  Created by Paul Wadsworth on 05/03/2016.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import RealmSwift
import CoreLocation
import ObjectMapper

class MLocation: Object, Mappable {
    
    var rLocation: CLLocation {
        set {
            _rLatitude = newValue.coordinate.latitude
            _rLongitude = newValue.coordinate.longitude
            _rTimeStamp = newValue.timestamp
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
    
    // MARK: > ObjectMapper
    required convenience init?(_ map: Map) {
        self.init()
    }    
}

extension MLocation {
    
    // MARK: > Mappable
    func mapping(map: Map) {
        
        xUpdate {
            self._rLatitude <- map["latitude"]
            self._rLongitude <- map["longitude"]
            self._rTimeStamp <- map["timestamp"]
        }
    }
}



