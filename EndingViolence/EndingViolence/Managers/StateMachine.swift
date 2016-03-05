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
    
    init(alertManager: AlertManager) {
        self.alertManager = alertManager
        super.init(states: [InactiveState(alertManager: alertManager), StandbyState(alertManager: alertManager), AlarmState(alertManager: alertManager)])
    }
}


class InactiveState: EVState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        alertManager.stopAllMonitoring()
    }
}

class StandbyState: EVState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        alertManager.beginStandbyMonitoring()
    }
}

class AlarmState: EVState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        if previousState is InactiveState {
            alertManager.beginStandbyMonitoring()
        }
        alertManager.beginSendingAlarm()
    }
}

class EVState: GKState {
    let alertManager: AlertManager
    
    init(alertManager: AlertManager) {
        self.alertManager = alertManager
    }
}