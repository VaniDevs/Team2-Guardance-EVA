//
//  ModelMgr.swift
//  EndingViolence
//
//  Created by Paul Wadsworth on 05/03/2016.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import RealmSwift

struct ModelMgr {
    
    private let realm: Realm = try! Realm()
    
    var currentSession: MSession? {
        return getActiveSession()
    }
    
    private func getActiveSession() -> MSession? {
        return realm.objects(MSession.self).filter("isCurrentSession == true").first
    }
    
    private mutating func clearActiveSession() {
        
        if let activeSession = getActiveSession() {
            activeSession.xUpdate {
                activeSession.rIsCurrentSession = false
            }
        }
    }

    private mutating func newSession(user: User) -> MSession {

        clearActiveSession()
        
        let session = MSession()
        session.rUser = user
        session.rIsCurrentSession = true
        
        try! realm.write {
            realm.add(session)
        }
        return session
    }

}