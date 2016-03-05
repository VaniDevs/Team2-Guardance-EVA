//
//  LocationMgr.swift
//  EndingViolence
//
//  Created by Paul Wadsworth on 05/03/2016.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import RealmSwift


class M: Object {
    dynamic var <#id#> = 0
    dynamic var owner: Person? // to-one relationships must be optional
    let children = List<<#Child#>>()
    
    override static func primaryKey() -> String? {
        return "<#id#>"
    }
    
    override class func ignoredProperties() -> [String] {
        return [<#propertyname1#>,<#propertyname2#>]
    }
    
}

