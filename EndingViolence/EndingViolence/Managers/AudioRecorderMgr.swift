//
//  AudioRecorderMgr.swift
//  EndingViolence
//
//  Created by Paul Wadsworth on 06/03/2016.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import Foundation

import UIKit
import AVFoundation

class AudioRecorderMgr : NSObject {

    var audioRecorder: AVAudioRecorder?
    
    func newRecording() -> String? {
        
        if audioRecorder?.recording == true {
            print(__FUNCTION__, "Already recording")
            return nil
        }
        
        let filename = FilenameGenerator.uniqueNameFromName("sound") + ".caf"//".m4a"
        let soundFilePath = (documentPath() as NSString).stringByAppendingPathComponent(filename)
        let soundFileURL = NSURL(fileURLWithPath: soundFilePath)
        
        
        let recordSettings: [String : AnyObject] = [
            //AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatMPEG4AAC), // FIX: Can't figure how to get this to work
            AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue,
            AVEncoderBitRateKey: 16,
            AVNumberOfChannelsKey: 1,
            AVSampleRateKey: 22050.0//44100.0
        ]
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            audioRecorder = try AVAudioRecorder(URL: soundFileURL, settings: recordSettings)
            audioRecorder?.prepareToRecord()
            audioRecorder?.delegate = self
            return soundFilePath
            
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
            return nil

        } catch {
            print("audioSession error")
            return nil
        }
    }
    
    func start() {
        
        guard let recorder = audioRecorder else { return }
        
        if !recorder.recording {
            recorder.record()
        }
    }
    
    func finish() {
        
        guard let recorder = audioRecorder else { return }
        
        if recorder.recording {
            recorder.stop() // Closes the audio file
        }
    }
    
    func deleteCurrentRecording() {

        guard let recorder = audioRecorder else { return }
        
        if !recorder.recording {
            recorder.deleteRecording()
        }
    }
}

extension AudioRecorderMgr : AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print(self, __FUNCTION__, "Finished recording audio, success=\(flag)")
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder, error: NSError?) {
        print(self, __FUNCTION__, error?.localizedDescription)
    }
}