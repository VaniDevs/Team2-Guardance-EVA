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
    
    let imageManager = ImageCaptureManager()
    var modelManager = ModelMgr()
    var coreLocationController = CoreLocationController()
    var audioRecorder = AudioRecorderMgr()

    let homeViewController: HomeViewController
    
    var timer: NSTimer?
    
    var session: MSession {
        return self.modelManager.currentSession ?? self.modelManager.newSession("teamteamdev")
    }

    init(homeViewController: HomeViewController) {
        self.homeViewController = homeViewController
        
        super.init(states: [InactiveState(imageManager: imageManager, homeViewController: homeViewController), StandbyState(imageManager: imageManager, homeViewController: homeViewController), AlarmState(imageManager: imageManager, homeViewController: homeViewController)])
        
        self.imageManager.setup()
        self.coreLocationController.start()
    }
    
    func capture() {
        imageManager.captureImage {image in
            
            let ses = self.session
            ses.addImage(image)
            ses.logLocation(self.coreLocationController.requestLocation())
        }
        print("Captured media")
    }
}


class InactiveState: EVState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)
        
        SM.timer?.invalidate()
        SM.timer = nil
        
        SM.modelManager.clearActiveSession()
        
        imageManager.stop()
        stopRecordingAudio()
        homeViewController.enterInactiveState()
    }
}

class StandbyState: EVState {
    override func didEnterWithPreviousState(previousState: GKState?) {
        super.didEnterWithPreviousState(previousState)
        imageManager.begin()

        startCapturing()
        startRecordingAudio()
        homeViewController.enterStandbyState()
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