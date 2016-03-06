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
    
    var stateMachine: StateMachine!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stateMachine = StateMachine(homeViewController: self)
        stateMachine?.enterState(InactiveState)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        configureView()
    }
    
    func configureView() {
        alertButton.titleLabel?.font = UIFont.LeagueGothic(48.0)
        alertButton.titleLabel?.numberOfLines = 0
        alertButton.titleLabel?.textAlignment = .Center
        
        alertButton.setTitle("Activate\nAlarm", forState: .Normal)
        alertButton.setTitleColor(.whiteColor(), forState: .Normal)
        
//        alertButton.setTitle("Activate\nAlarm", forState: .Highlighted)
//        alertButton.setTitleColor(.evaRed(), forState: .Highlighted)

        alertButton.setTitle("Disable\nAlarm", forState: .Selected)
        alertButton.setTitleColor(.evaRed(), forState: .Selected)
    }

    @IBAction func alertTapped(sender: AnyObject) {

        switch stateMachine.currentState {
            case is AlarmState:
                stateMachine.enterState(InactiveState)
            default:
                stateMachine.enterState(AlarmState)
        }
    }
    
    @IBAction func standbyTapped(sender: AnyObject) {
        
        switch stateMachine.currentState {
        case is StandbyState:
            stateMachine.enterState(InactiveState)
        default:
            stateMachine.enterState(StandbyState)
        }
    }
    
    func enterInactiveState() {
        view.backgroundColor = .whiteColor()
        alertButton.selected = false
    }

    func enterStandbyState() {
        view.backgroundColor = .evaOrangeAlert()
    }

    func enterAlarmState() {
        view.backgroundColor = .evaRed()
        alertButton.selected = true
    }
}