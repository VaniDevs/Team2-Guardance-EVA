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
import CoreLocation

enum IVtag: Int {
    case Mic = 101, Camera, Location, Signal
}

class HomeViewController: UIViewController {
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var standbyButton: UIButton!
    @IBOutlet weak var alarmWaves: UIImageView!
    @IBOutlet weak var offlineView: UIView!
    @IBOutlet weak var countdownTimer: UILabel!
    
    @IBOutlet weak var onboardingView: UIView!
    
    @IBOutlet weak var hideOfflineViewConstrain: NSLayoutConstraint!
    @IBOutlet weak var showOfflineViewConstrain: NSLayoutConstraint!

    @IBOutlet weak var settings: UIButton!
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
    var alertManager: AlertManager!

    let locManager = CLLocationManager()
    
    var reachability = try? Reachability.reachabilityForInternetConnection()
    
    let onboardImages: [UIImage] = [UIImage(named: "onboard1")!, UIImage(named: "onboard2")!, UIImage(named: "onboard3")!, UIImage(named: "onboard4")!, UIImage(named: "onboard5")!, UIImage(named: "onboard6")!, ]
    var onboardIndex: Int = 0
    
    @IBOutlet weak var onboardImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter()
            .addObserver(self,
                         selector: "reachabilityChanged:",
                         name: ReachabilityChangedNotification,
                         object: reachability
        )
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        alertManager = AlertManager(homeViewController: self)
        stateMachine = StateMachine(homeViewController: self)
        stateMachine?.enterState(OnboardState)
        
        configureView()
        
        startReachability()
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
            let gr = UITapGestureRecognizer(target: self, action: "tapMicButton")
            micIV.addGestureRecognizer(gr)
        }
        if !signalAuthorized {
            signalIV.image = UIImage(named: "singal_disabled")
        }
        if !locationAuthorized {
            locationIV.image = UIImage(named: "gps_disabled")
            let gr = UITapGestureRecognizer(target: self, action: "tapLocButton")
            locationIV.addGestureRecognizer(gr)
        }
        if !cameraAuthorized {
            cameraIV.image = UIImage(named: "cam_disabled")
            let gr = UITapGestureRecognizer(target: self, action: "tapCamButton")
            cameraIV.addGestureRecognizer(gr)
        }
        
        countdownTimer.textColor = .whiteColor()
        countdownTimer.font = UIFont.LeagueGothic(20.0)
        
        settings.tintColor = .evaYellowDull()
        offlineView.backgroundColor = .evaRed()
        
        showOfflineView((reachability?.isReachable())!)
    }
    
    func setIconsActive() {
        // I am ashamed at how much rewritten code is here
        if self.micAuthorized {
            self.micIV.image = UIImage(named: "mic_active")
            self.micIV.tintColor = .whiteColor()
            self.micIV.gestureRecognizers = nil
        }
        if self.signalAuthorized {
            self.signalIV.image = UIImage(named: "singal_active")
            self.signalIV.tintColor = .whiteColor()
            self.signalIV.gestureRecognizers = nil
        }
        if self.locationAuthorized {
            self.locationIV.image = UIImage(named: "gps_active")
            self.locationIV.tintColor = .whiteColor()
            self.locationIV.gestureRecognizers = nil
        }
        if self.cameraAuthorized {
            self.cameraIV.image = UIImage(named: "cam_active")
            self.cameraIV.tintColor = .whiteColor()
            self.cameraIV.gestureRecognizers = nil
        }
    }

    func showOfflineView(hidden: Bool) {
        UIView.animateWithDuration(0.4) {
            if hidden {
                self.hideOfflineViewConstrain.priority = UILayoutPriorityDefaultHigh
                self.showOfflineViewConstrain.priority = UILayoutPriorityDefaultLow
            } else {
                self.hideOfflineViewConstrain.priority = UILayoutPriorityDefaultLow
                self.showOfflineViewConstrain.priority = UILayoutPriorityDefaultHigh
            }
            self.view.layoutIfNeeded()
        }
    }
    
    // Reachability
    func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        
        dispatchAsync { 
            self.showOfflineView(reachability.isReachable())
        }
    }
    
    private func startReachability() {
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    //MARK: IBActions
    @IBAction func alertTapped(sender: AnyObject) {

        switch stateMachine.currentState {
            case is AlarmState:
                alertManager.promptDisable()
            // stateMachine.enterState(InactiveState)
            default:
                stateMachine.enterState(AlarmState)
        }
    }
    
    @IBAction func standbyTapped(sender: AnyObject) {
        
        switch stateMachine.currentState {
        case is StandbyState:
            // stateMachine.enterState(InactiveState)
            // prompt to disable )
            alertManager.promptDisable()
        default:
            stateMachine.enterState(StandbyState)
        }
    }
    
    func tapCamButton() {
        presentPermissionsAlert("Camera")
    }
    
    func tapLocButton() {
        presentPermissionsAlert("Location")
    }

    func tapMicButton() {
        presentPermissionsAlert("Microphone")
    }
    
    func presentPermissionsAlert(type: String) {
        let alert = UIAlertController(title: "\(type) Not Authorized", message: "Please grant \(type.lowercaseString) permissions in settings", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .Default, handler: { (_) in
            if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(url)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }

    //MARK: State config
    func enterInactiveState() {
        onboardingView.hidden = true
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DataBrowser" {
            let nav = segue.destinationViewController as! UINavigationController
            let vc = nav.viewControllers.first as! HistoryViewController
            vc.modelManager = stateMachine.modelManager
        }
    }

    func startOnboarding() {
        onboardImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "nextOnboard"))
        onboardImageView.userInteractionEnabled = true
        alertButton.userInteractionEnabled = false
        standbyButton.userInteractionEnabled = false
    }
    
    
    //MARK: Onboarding
    func nextOnboard() {
        onboardIndex += 1
        if 0..<onboardImages.count ~= onboardIndex {
            onboardImageView.image = onboardImages[onboardIndex]
            switch onboardIndex {
            case 2:
                askForGPSPermission()
            case 3:
                askForAudioPermission()
            case 4:
                askForCameraPermission()
                onboardingView.alpha = 0.8
                onboardImageView.alpha = 0.8
            case 5,6:
                onboardingView.alpha = 0.8
                onboardImageView.alpha = 0.8
            default:
                break
            }
        } else {
            stateMachine.enterState(InactiveState)
            alertButton.userInteractionEnabled = true
            standbyButton.userInteractionEnabled = true
        }
    }
    
    @IBAction func askForCameraPermission() {
        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { (success) -> Void in
            print("AVCaptureDevice permission: \(success)")
        })
    }
    
    @IBAction func askForAudioPermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { (perm) in
            print("AVAudioSession permission: \(perm)")
        }
    }
    
    @IBAction func askForGPSPermission() {
        locManager.requestAlwaysAuthorization()
    }
}