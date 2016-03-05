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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func alertTapped(sender: AnyObject) {
        // if !alertMode start recording
        // Send message to api
    }
    
    @IBAction func standbyTapped(sender: AnyObject) {
        // Enter alert mode: start GPS, recording
    }
}

