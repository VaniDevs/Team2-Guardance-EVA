//
//  LoginViewController.swift
//  EndingViolence
//
//  Created by Steven Thompson on 2016-03-05.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation

class LoginViewController: UIViewController {
    let locManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func askForCameraPermission(sender: AnyObject) {
        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { (success) -> Void in
            print("AVCaptureDevice permission: \(success)")
        })
    }
    
    @IBAction func askForAudioPermission(sender: AnyObject) {
        AVAudioSession.sharedInstance().requestRecordPermission { (perm) in
            print("AVAudioSession permission: \(perm)")
        }
    }
    
    @IBAction func askForGPSPermission(sender: AnyObject) {
        locManager.requestAlwaysAuthorization()
    }
    
    @IBAction func login(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(UserLoggedIn, object: nil)
    }
}
