//
//  MSession.swift
//  EndingViolence
//
//  Created by Paul Wadsworth on 05/03/2016.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import RealmSwift
import CoreLocation

class MSession: Object {

    dynamic var uuid = 0
    dynamic var rUser: User = ""
    dynamic var rStartTime = NSDate()
    dynamic var rIsCurrentSession = false
    
    let locations = List<MLocation>()

    //    dynamic var owner: Person? // to-one relationships must be optional
//    let children = List<<#Child#>>()
//    
//    override static func primaryKey() -> String? {
//        return "<#id#>"
//    }
//    
//    override class func ignoredProperties() -> [String] {
//        return [<#propertyname1#>,<#propertyname2#>]
//    }
    
}

extension MSession {
    
    func logLocation(location: CLLocation) {
        
        guard let realm = self.realm else { return }
        
        let location = MLocation()
        try! realm.write {
            realm.add(location)
        }
    }
}