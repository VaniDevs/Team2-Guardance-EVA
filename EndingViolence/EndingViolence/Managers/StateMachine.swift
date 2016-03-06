//
//  StateMachine.swift
//  EndingViolence
//
//  Created by Steven Thompson on 2016-03-05.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import UIKit
import GameplayKit

class StateMachine: GKStateMachine {
    let imageManager = ImageCaptureManager()
    var modelManager = ModelMgr()
    var coreLocationController = CoreLocationController()

    let homeViewController: HomeViewController
    
    var timer: NSTimer?

    init(homeViewController: HomeViewController) {
        self.homeViewController = homeViewController
        
        super.init(states: [InactiveState(imageManager: imageManager, homeViewController: homeViewController), StandbyState(imageManager: imageManager, homeViewController: homeViewController), AlarmState(imageManager: imageManager, homeViewController: homeViewController)])
        
        self.imageManager.setup()
        self.coreLocationController.start()
    }
    
    func capture() {
        imageManager.captureImage {image in
            if let ses = self.modelManager.currentSession {
                ses.addImage(image)
                ses.logLocation(self.coreLocationController.requestLocation())
            } else {
                let ses = self.modelManager.newSession("teamteamdev")
                ses.addImage(image)
                ses.logLocation(self.coreLocationController.requestLocation())
            }
        }
        NSLog("Captured media")
    }
}


class InactiveState: EVState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)
        
        SM.timer?.invalidate()
        SM.timer = nil
        
        SM.modelManager.clearActiveSession()
        
        imageManager.stop()
        homeViewController.enterInactiveState()
    }
}

class StandbyState: EVState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)
        imageManager.begin()

        SM.timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: SM, selector: Selector("capture"), userInfo: nil, repeats: true)
        SM.timer?.fire() // session begins
        
        homeViewController.enterStandbyState()
        
        // nextState  = prompt login
        
        // start timer
        // after X minutes, prompt user
        // if correct password, prompt again
        // have option to enter
        // if incorrect, switch to alarm.
    }
}

class AlarmState: EVState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)
        
        if previousState is InactiveState {
            imageManager.begin()

            SM.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: SM, selector: Selector("capture"), userInfo: nil, repeats: true)
            SM.timer?.fire()
        }
        homeViewController.enterAlarmState()
        
        if let session = SM.modelManager.currentSession {
            dispatchAsyncAfter(8) {
                ClientMgr.raiseTheAlarm(session)
            }
        }
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        if stateClass is StandbyState.Type {
            return false
        }
        
        return true
    }
}

class EVState: GKState {
    let homeViewController: HomeViewController
    let imageManager: ImageCaptureManager

    init(imageManager: ImageCaptureManager, homeViewController: HomeViewController) {
        self.imageManager = imageManager
        self.homeViewController = homeViewController
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)

        NSLog("Entered \(self) from \(previousState)")
    }
}

extension EVState {
    
    var SM: StateMachine {
        return stateMachine as! StateMachine
    }
}