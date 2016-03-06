//
//  MSession.swift
//  EndingViolence
//
//  Created by Paul Wadsworth on 05/03/2016.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import RealmSwift
import CoreLocation
import ObjectMapper

class MSession: Object, Mappable {

    dynamic var uuid = 0
    dynamic var rUser: User = ""
    dynamic var rStartTime = NSDate()
    dynamic var rIsCurrentSession = false
    
    var locations = List<MLocation>()
    let imgs = List<MImage>()

    // MARK: > ObjectMapper
    required convenience init?(_ map: Map) {
        self.init()
    }
}

extension MSession {
    
    func logLocation(location: CLLocation) {
        
        guard let realm = self.realm else { return }
        
        let newlocation = MLocation()
        newlocation.rLocation = location
        
        try! realm.write {
            realm.add(newlocation)
        }
    }

    func addImage(image: UIImage) {
        
        guard let realm = self.realm else { return }
        
        let newImg = MImage()
        newImg.rImage = image
        
        try! realm.write {
            realm.add(newImg)
        }
    }
}


extension MSession {
    
    // MARK: > Mappable
    func mapping(map: Map) {
        
        xUpdate {
            self.rUser <- map["user"]
            self.rStartTime <- map["startTime"]
            self.locations <- map["locations"]
        }
    }
}



