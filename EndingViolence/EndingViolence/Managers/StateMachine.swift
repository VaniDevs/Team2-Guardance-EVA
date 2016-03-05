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
    let alertManager: AlertManager
    let homeViewController: HomeViewController

    init(alertManager: AlertManager, homeViewController: HomeViewController) {
        self.alertManager = alertManager
        self.homeViewController = homeViewController
        
        super.init(states: [InactiveState(alertManager: alertManager, homeViewController: homeViewController), StandbyState(alertManager: alertManager, homeViewController: homeViewController), AlarmState(alertManager: alertManager, homeViewController: homeViewController)])
    }
}


class InactiveState: EVState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)

        alertManager.stopAllMonitoring()
        homeViewController.enterInactiveState()
    }
}

class StandbyState: EVState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)

        alertManager.beginStandbyMonitoring()
        homeViewController.enterStandbyState()
    }
}

class AlarmState: EVState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)
        
        if previousState is InactiveState {
            alertManager.beginStandbyMonitoring()
        }
        alertManager.beginSendingAlarm()
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
    let alertManager: AlertManager
    let homeViewController: HomeViewController

    init(alertManager: AlertManager, homeViewController: HomeViewController) {
        self.homeViewController = homeViewController
        self.alertManager = alertManager
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)

        NSLog("Entered \(self) from \(previousState)")
    }
}