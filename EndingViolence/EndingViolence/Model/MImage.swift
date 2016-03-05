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
            _rImgData = UIImagePNGRepresentation(rImage)
        }
        get {
            guard let imgData = _rImgData, let img = UIImage(data: imgData) else {
                return UIImage()
            }
            return img
        }
    }
    
    dynamic var _rImgData: NSData?
    
    override class func ignoredProperties() -> [String] {
        return ["rImage"]
    }
    
}


