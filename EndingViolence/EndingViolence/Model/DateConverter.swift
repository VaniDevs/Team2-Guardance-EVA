//
//  DateConverter.swift
//  EndingViolence
//
//  Created by Paul Wadsworth on 05/03/2016.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import ObjectMapper

struct DateTransform : TransformType {
    
    typealias Object = NSDate
    typealias JSON = String
    
    // ISO 8601  e.g. 2015-12-23T14:32:33.194
    static let ISO8601DateFormatter: NSDateFormatter = {
        
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(name: "UTC")
        //formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        return formatter
    }()

    func transformFromJSON(value: AnyObject?) -> Object? {
        
        guard let _ = value else { return nil }
        
        fatalError("TODO: \(self.dynamicType) \(__FUNCTION__)")
    }
    
    func transformToJSON(value: Object?) -> JSON? {
        
        guard let date = value else { return nil }
        
        return DateTransform.ISO8601DateFormatter.stringFromDate(date)
    }
}
