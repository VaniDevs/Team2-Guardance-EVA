//
//  HomeViewController.swift
//  EndingViolence
//
//  Created by Steven Thompson on 2016-03-05.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import UIKit

class HomeViewController: EVViewController {
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var standbyButton: UIButton!
    
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var connectionButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    var stateMachine: StateMachine?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stateMachine = StateMachine(alertManager: AlertManager(), homeViewController: self)
    }

    @IBAction func alertTapped(sender: AnyObject) {
        if let sm = stateMachine {
            if sm.currentState is AlarmState {
                sm.enterState(InactiveState)
            } else {
                sm.enterState(AlarmState)
            }
        }
    }
    
    @IBAction func standbyTapped(sender: AnyObject) {
        if let sm = stateMachine {
            if sm.currentState is StandbyState {
                sm.enterState(InactiveState)
            } else {
                sm.enterState(StandbyState)
            }
        }
    }
    
    func enterInactiveState() {
        view.backgroundColor = .whiteColor()
    }

    func enterStandbyState() {
        view.backgroundColor = .orangeColor()
    }

    func enterAlarmState() {
        view.backgroundColor = .redColor()
    }
}