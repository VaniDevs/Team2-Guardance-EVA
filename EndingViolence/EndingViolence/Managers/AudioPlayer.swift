//
//  AudioPlayer.swift
//  EndingViolence
//
//  Created by Paul Wadsworth on 06/03/2016.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import AVFoundation

class AudioPlayer : NSObject {
    
    typealias AudioPlayerOnCompleteHandler = (success: Bool)->()
    
    private var audioPlayer: AVAudioPlayer?
    private var onComplete: AudioPlayerOnCompleteHandler?
    
    func loadFile(fullpath: String) {
        
        let soundFileURL = NSURL(fileURLWithPath: fullpath)

        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: soundFileURL)
            audioPlayer?.delegate = self
        } catch let error as NSError {
            print("audioPlayer error: \(error.localizedDescription)")
        } catch {
            print("audioPlayer error")
        }
    }
    
    func play(onComplete: AudioPlayerOnCompleteHandler?) {
        self.onComplete = onComplete
        audioPlayer?.play()
    }
    
    func stop() {
        audioPlayer?.stop()
    }
}

extension AudioPlayer : AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        onComplete?(success: flag)
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        print("Audio Play Decode Error")
    }
}