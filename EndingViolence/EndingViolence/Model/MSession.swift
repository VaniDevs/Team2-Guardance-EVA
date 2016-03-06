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

    enum Properties : String {
        case StartTime = "rStartTime"
    }
    
    dynamic var uuid = NSUUID().UUIDString
    dynamic var rUser: User = ""
    dynamic var rStartTime = NSDate()
    dynamic var rIsCurrentSession = false
    dynamic var rAudioFilePath: String?
    
    var rLocations = List<MLocation>()
    let rImgs = List<MImage>()

    // MARK: > ObjectMapper
    required convenience init?(_ map: Map) {
        self.init()
    }
}

extension MSession {
    
    var latestImage: MImage? {
        return rImgs.last
    }
    
    var latestCoordinate: MLocation? {
        return rLocations.last
    }
    
    func logLocation(location: CLLocation) {
        
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

    func imageDataForIndex(index: Int) -> NSData? {
        
        guard !rImgs.isEmpty else { return nil }
        
        return rImgs[clamp(index, 0, rImgs.count-1)]._rImgData
    }
}


extension MSession {
    
    // MARK: > Mappable
    func mapping(map: Map) {
        
        xUpdate {
            self.rUser <- map["user"]
            self.rStartTime <- (map["startTime"], DateTransform())
        }
    }
    
    func locationsToDictArray() -> [JSONDict] {
        return rLocations.map {
            $0.toJSON()
        }
    }
}



