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
    let imgs = List<MImage>()
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