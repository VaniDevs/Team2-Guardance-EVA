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

    dynamic var uuid = NSUUID().UUIDString
    dynamic var rUser: User = ""
    dynamic var rStartTime = NSDate()
    dynamic var rIsCurrentSession = false
    
    var rLocations = List<MLocation>()
    let rImgs = List<MImage>()

    // MARK: > ObjectMapper
    required convenience init?(_ map: Map) {
        self.init()
    }
}

extension MSession {
    
    func logLocation(location: CLLocation) {
        
        print(self, __FUNCTION__)
        
        let newlocation = MLocation()
        newlocation.rLocation = location
        
        xUpdate {
            self.rLocations.append(newlocation)
        }
    }

    func addImage(image: UIImage) {
        
        let newImg = MImage()
        newImg.rImage = image
        
        xUpdate {
            self.rImgs.append(newImg)
        }
    }
}


extension MSession {
    
    // MARK: > Mappable
    func mapping(map: Map) {
        
        xUpdate {
            self.rUser <- map["user"]
            self.rStartTime <- map["startTime"]
            self.rLocations <- map["locations"]
        }
    }
}



