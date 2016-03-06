//
//  AlertManager.swift
//  EndingViolence
//
//  Created by Kaitlyn Melton on 2016-03-05.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import Foundation
import UIKit

public class AlertManager {
    
    let homeViewController: HomeViewController
    var passwordField: UITextField = UITextField()
    let password = "password"
    
    init(homeViewController: HomeViewController) {
        self.homeViewController = homeViewController
        self.passwordField.secureTextEntry = true
    }
    
    func configurationTextField(textField: UITextField!)
    {
        print("configuring text field")
        if let _ = textField {
            textField.secureTextEntry = true
            self.passwordField = textField        //Save reference to the UITextField
        }
    }
    
    
    func handleCancel(alertView: UIAlertAction!)
    {
        // just close the box.
        var message = "System is inactive"
        print("User has clicked Cancel button.")
        switch homeViewController.stateMachine.currentState {
        case is AlarmState:
            message = "Returning to Alarm. Location data will continue being sent to security."
        case is StandbyState:
            message = "Returning to Standby."
        default:
            break
        }
    }
    
    func verifyPassword(alertView: UIAlertAction!)
    {
        // check password.
        print("User has entered password. Verifying.")
        print(self.passwordField.text)
        
        let enteredPassword = self.passwordField.text
        if (isPasswordCorrect(enteredPassword))
        {
            if (homeViewController.stateMachine.currentState is AlarmState)
            {
                let alert = UIAlertController(title: "Password Correct", message: "We have stopped collecting information, and your security company has been notified that you have deactivated your alarms. Note that they may still call to confirm your safety.", preferredStyle:UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in }))
                homeViewController.presentViewController(alert, animated: true, completion: {})
            }
            homeViewController.stateMachine.enterState(InactiveState)
        }
        else
        {
            let alert = UIAlertController(title: "Password Incorrect", message: "Must enter password to disable. ", preferredStyle:UIAlertControllerStyle.Alert)
            
            alert.addTextFieldWithConfigurationHandler(configurationTextField)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: (handleCancel)))
            alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.Default, handler: (verifyPassword)))
            homeViewController.presentViewController(alert, animated: true, completion: {})
        }
    }
    
    
    func promptDisable() { // persist a representation of this todo item in NSUserDefaults
        
        let alert = UIAlertController(title: "Password Required", message: "Must enter password to disable. ", preferredStyle:
            UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: (handleCancel)))
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.Default, handler: (verifyPassword)))
        
        homeViewController.presentViewController(alert, animated: true, completion: {})
        
    }
    
    func isPasswordCorrect(enteredPassword: String!) -> Bool 
    {
        // TODO? Query somewhere for actual password?
        return (enteredPassword == self.password)
    }
    
}