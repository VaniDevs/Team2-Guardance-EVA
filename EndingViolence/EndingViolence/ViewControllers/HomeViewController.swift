//
//  HomeViewController.swift
//  EndingViolence
//
//  Created by Steven Thompson on 2016-03-05.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import UIKit
import ReachabilitySwift
import AVFoundation

class HomeViewController: EVViewController {
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var standbyButton: UIButton!
    @IBOutlet weak var alarmWaves: UIImageView!
    
    @IBOutlet weak var micIV: UIImageView!
    var micAuthorized: Bool {
        return AVAudioSession.sharedInstance().recordPermission() == .Granted
    }
    @IBOutlet weak var cameraIV: UIImageView!
    var cameraAuthorized: Bool {
        return AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) == .Authorized
    }
    @IBOutlet weak var locationIV: UIImageView!
    var locationAuthorized: Bool {
        return CoreLocationController.isAuthorized()
    }
    @IBOutlet weak var signalIV: UIImageView!
    var signalAuthorized: Bool {
        do {
            return try Reachability.reachabilityForInternetConnection().isReachable()
        } catch {
            print("Reachable is no")
            return false
        }
    }
    
    var stateMachine: StateMachine!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        stateMachine = StateMachine(homeViewController: self)
        stateMachine?.enterState(InactiveState)
        
        configureView()
    }
    
    func configureView() {
        alarmWaves.alpha = 0.0
        alarmWaves.animationImages = [UIImage(named: "animation_alarm_1")!, UIImage(named: "animation_alarm_2")!, UIImage(named: "animation_alarm_3")!, UIImage(named: "animation_alarm_4")!, UIImage(named: "animation_alarm_5")!]
        alarmWaves.tintColor = .whiteColor()
        
        standbyButton.titleLabel?.font = UIFont.LeagueGothic(30.0)
        standbyButton.setTitle("Enter High Alert", forState: .Normal)
        standbyButton.setTitleColor(.whiteColor(), forState: .Normal)
        standbyButton.setTitle("Leave High Alert", forState: .Selected)
        standbyButton.setTitleColor(.evaOrangeAlert(), forState: .Selected)

        alertButton.titleLabel?.font = UIFont.LeagueGothic(48.0)
        alertButton.titleLabel?.numberOfLines = 0
        alertButton.titleLabel?.textAlignment = .Center
        
        alertButton.setTitle("Activate\nAlarm", forState: .Normal)
        alertButton.setTitleColor(.whiteColor(), forState: .Normal)
        
//        alertButton.setTitle("Activate\nAlarm", forState: .Highlighted)
//        alertButton.setTitleColor(.evaRed(), forState: .Highlighted)

        alertButton.setTitle("Disable\nAlarm", forState: .Selected)
        alertButton.setTitleColor(.evaRed(), forState: .Selected)
        
        if !micAuthorized {
            micIV.image = UIImage(named: "mic_disabled")
        }
        if !signalAuthorized {
            signalIV.image = UIImage(named: "singal_disabled")
        }
        if !locationAuthorized {
            locationIV.image = UIImage(named: "gps_disabled")
        }
        if !cameraAuthorized {
            cameraIV.image = UIImage(named: "cam_disabled")
        }
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
        standbyButton.selected = false
        standbyButton.enabled = true
        standbyButton.tintColor = .evaOrangeAlert()
        
        alarmWaves.stopAnimating()
        UIView.animateWithDuration(0.2) { 
            self.alarmWaves.alpha = 0.0
        }
        
        if micAuthorized {
            micIV.image = UIImage(named: "mic_inactive")
            micIV.tintColor = .evaRed()
        }
        if signalAuthorized {
            signalIV.image = UIImage(named: "singal_inactive")
            signalIV.tintColor = .evaRed()
        }
        if locationAuthorized {
            locationIV.image = UIImage(named: "gps_inactive")
            locationIV.tintColor = .evaRed()
        }
        if cameraAuthorized {
            cameraIV.image = UIImage(named: "cam_inactive")
            cameraIV.tintColor = .evaRed()
        }
    }

    func enterStandbyState() {
        view.backgroundColor = .evaOrangeAlert()
        standbyButton.selected = true

        setIconsActive()
    }

    func enterAlarmState() {
        view.backgroundColor = .evaRed()
        alertButton.selected = true
        standbyButton.selected = false
        standbyButton.enabled = false
        standbyButton.tintColor = .grayColor()

        UIView.animateWithDuration(0.2) {
            self.alarmWaves.alpha = 1.0
        }
        alarmWaves.animationDuration = 1.0
        alarmWaves.animationRepeatCount = 0
        alarmWaves.startAnimating()
        
        setIconsActive()
    }
    
    func setIconsActive() {
        // I am ashamed at how much rewritten code is here
        if micAuthorized {
            micIV.image = UIImage(named: "mic_active")
            micIV.tintColor = .whiteColor()
        }
        if signalAuthorized {
            signalIV.image = UIImage(named: "singal_active")
            signalIV.tintColor = .whiteColor()
        }
        if locationAuthorized {
            locationIV.image = UIImage(named: "gps_active")
            locationIV.tintColor = .whiteColor()
        }
        if cameraAuthorized {
            cameraIV.image = UIImage(named: "cam_active")
            cameraIV.tintColor = .whiteColor()
        }
    }
}