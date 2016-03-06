//
//  StateMachine.swift
//  EndingViolence
//
//  Created by Steven Thompson on 2016-03-05.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import UIKit
import GameplayKit
import AudioToolbox
import AudioToolbox.AudioServices
import AVFoundation

class StateMachine: GKStateMachine {
    
    let imageManager = ImageCaptureManager()
    var modelManager = ModelMgr()
    var coreLocationController = CoreLocationController()
    var audioRecorder = AudioRecorderMgr()

    let homeViewController: HomeViewController
    
    var timer: NSTimer?
    var standbyCountdown: NSTimer?
    let numMinutes: Int = 1
    var remainingSeconds: Int
    
    var session: MSession {
        return self.modelManager.currentSession ?? self.modelManager.newSession("teamteamdev")
    }

    init(homeViewController: HomeViewController) {
        self.homeViewController = homeViewController
        self.remainingSeconds = (self.numMinutes * 60)
        
        super.init(states: [InactiveState(imageManager: imageManager, homeViewController: homeViewController), StandbyState(imageManager: imageManager, homeViewController: homeViewController), AlarmState(imageManager: imageManager, homeViewController: homeViewController), OnboardState(imageManager: imageManager, homeViewController: homeViewController)])
        
        self.imageManager.setup()
    }
    
    func capture() {
        imageManager.captureImage {image in
    
            let ses = self.session
            ses.addImage(image)
            ses.logLocation(self.coreLocationController.requestLocation())
        }
        print("Captured media")
    }
    
    func countdown(){
        self.remainingSeconds--
        
        let timeString = self.setTime(self.remainingSeconds)
         homeViewController.countdownTimer.text = "\(timeString) until alarm activates"
        
        if (self.remainingSeconds < 60){
            // AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, nil)
//            AudioServicesPlaySystemSoundWithCompletion(1320, nil)
            // BUZZ BUZZ BUZZ
            // BEEP BEEP BEEP
        }
        
        if (self.remainingSeconds == 0){
            homeViewController.stateMachine.enterState(AlarmState)
            self.standbyCountdown?.invalidate()
            self.standbyCountdown = nil
        }
    }
    
    func setTime(seconds: Int) -> String {
        let min: Int = seconds/60
        let sec: Int = seconds%60
        var secStr : String = "\(sec) "
        if (sec < 10){
            secStr = "0\(sec)"
        }
        
        let timeString = "\(min):\(secStr)"
        print(timeString)
        return timeString
    }
    
}


class InactiveState: EVState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)
        
        SM.timer?.invalidate()
        SM.timer = nil
        
        SM.modelManager.clearActiveSession()
        SM.coreLocationController.start()
        
        imageManager.stop()
        stopRecordingAudio()
        homeViewController.enterInactiveState()
    }
}

class StandbyState: EVState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)
        imageManager.begin()
        
        SM.remainingSeconds = (SM.numMinutes * 60)

        startCapturing()
        startRecordingAudio()
        homeViewController.enterStandbyState()
        
        homeViewController.countdownTimer.hidden = false

        SM.standbyCountdown = NSTimer.scheduledTimerWithTimeInterval(1.0, target: SM, selector: Selector("countdown"), userInfo: nil, repeats: true)
        SM.standbyCountdown?.fire() // countdown timer begins
    }
    
    override func willExitWithNextState(nextState: GKState) {
        super.willExitWithNextState(nextState)
        
        SM.standbyCountdown?.invalidate()
        SM.standbyCountdown = nil
        
        homeViewController.countdownTimer.hidden = true
    }
}


class AlarmState: EVState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)
        
        if previousState is InactiveState {
            imageManager.begin()

            startCapturing()
        }
        homeViewController.enterAlarmState()
        
        startRecordingAudio()
        sendAlarm()
        
        // TODO: Start uploading images
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        if stateClass is StandbyState.Type {
            return false
        }
        
        return true
    }
    
    private func sendAlarm() {
        let ses = SM.session
        ses.logLocation(SM.coreLocationController.requestLocation())
        ClientMgr.raiseTheAlarm(ses)
    }
}

class OnboardState: EVState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)

        homeViewController.startOnboarding()
    }
    
    override func willExitWithNextState(nextState: GKState) {
        super.willExitWithNextState(nextState)
        
        homeViewController.alertButton.userInteractionEnabled = true
        homeViewController.standbyButton.userInteractionEnabled = true
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

extension EVState {
    
    var SM: StateMachine {
        return stateMachine as! StateMachine
    }
    
    func startCapturing() {
        SM.timer = NSTimer.scheduledTimerWithTimeInterval(10.0, target: SM, selector: Selector("capture"), userInfo: nil, repeats: true)
        SM.timer?.fire()
    }
    
    func startRecordingAudio() {
    
        if let audioFilePath = SM.audioRecorder.newRecording() {
            print("audioFilePath: \(audioFilePath)")
            
            let session = SM.session
            session.xUpdate {
                session.rAudioFilePath = audioFilePath
            }
            
            SM.audioRecorder.start()
        }
    }
    
    func stopRecordingAudio() {
        SM.audioRecorder.finish()
    }
}