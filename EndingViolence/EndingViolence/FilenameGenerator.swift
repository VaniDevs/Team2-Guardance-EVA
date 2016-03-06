//
//  FilenameGenerator.swift
//  EndingViolence
//
//  Created by Paul Wadsworth on 05/03/2016.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import Foundation

struct FilenameGenerator {
    
    private static let keyCount = "FilenameGenerator-Count"
    private static var defaults = NSUserDefaults.standardUserDefaults()

    private static var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMMyyyy-hh:mm:ss"
        return formatter
    }()
    
    static func uniqueNameFromName(name: String) -> String {
        
        let dateString = dateFormatter.stringFromDate(NSDate())
        return name + dateString + "\(count)"
    }
    
    private static var count: Int {
        return defaults.integerForKey(keyCount) ?? 0
    }
    
    private static func incCount() -> Int {
        let newCount = count + 1
        defaults.setInteger(newCount, forKey: keyCount)
        return newCount
    }
}

