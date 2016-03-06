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
    let homeViewController: HomeViewController

    init(homeViewController: HomeViewController) {
        self.homeViewController = homeViewController
        
        super.init(states: [InactiveState(imageManager: imageManager, homeViewController: homeViewController), StandbyState(imageManager: imageManager, homeViewController: homeViewController), AlarmState(imageManager: imageManager, homeViewController: homeViewController)])
    }
}


class InactiveState: EVState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)

        imageManager.stop()
        homeViewController.enterInactiveState()
    }
}

class StandbyState: EVState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)

        imageManager.begin()
        homeViewController.enterStandbyState()
    }
}

class AlarmState: EVState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)
        
        if let prev = previousState where prev is InactiveState {
            imageManager.begin()
        }
        homeViewController.enterAlarmState()
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