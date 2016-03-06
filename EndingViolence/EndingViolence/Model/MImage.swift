//
//  MImage.swift
//  EndingViolence
//
//  Created by Paul Wadsworth on 05/03/2016.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import RealmSwift

class MImage: Object {
    
    var rImage: UIImage {
        set {
            _rImgData = UIImageJPEGRepresentation(rImage, 0.8)
        }
        get {
            guard let imgData = _rImgData, let img = UIImage(data: imgData) else {
                return UIImage()
            }
            return img
        }
    }
    
    dynamic var _rImgData: NSData?
    dynamic var rImageUploaded = false
    
    override class func ignoredProperties() -> [String] {
        return ["rImage"]
    }
    
}


