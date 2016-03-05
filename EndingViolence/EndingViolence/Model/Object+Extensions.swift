//
//  Object+Extensions.swift
//  EndingViolence
//
//  Created by Paul Wadsworth on 05/03/2016.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import RealmSwift

extension Object {
    
    var xIsPersisted: Bool {
        return (realm != nil)
    }
    
    func xUpdate(block: ()->()) {
        
        if xIsPersisted {
            _tryBlock("xUpdate") {
                block()
            }
        } else {
            block()
        }
    }
    
    func xDelete(obj: Object) {
        
        guard xIsPersisted else { return }
        
        _tryBlock("xDelete") {
            self.realm!.delete(obj)
        }
    }
    
    func xHasProperty(name: String) -> Bool {
        return objectSchema.properties.map{ $0.name }.contains(name)
    }
    
    private func _tryBlock(tag: String, block: ()->()) {
        
        do {
            try realm?.write {
                block()
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("\(self).\(tag) - failed!")
        }
    }
}

