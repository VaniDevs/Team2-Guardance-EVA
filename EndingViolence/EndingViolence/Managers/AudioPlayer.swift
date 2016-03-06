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
    
    var isPlaying: Bool {
        return audioPlayer?.playing ?? false
    }
    
    func loadFile(fullpath: String) {
        print(__FUNCTION__, fullpath)
        let soundFileURL = NSURL(fileURLWithPath: fullpath)

        guard NSFileManager.defaultManager().fileExistsAtPath(fullpath) else { return }
        
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
        do {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            print("Error setting audio category")
        }

        self.onComplete = onComplete
        
        guard let audioPlayer = self.audioPlayer else { return }

        if audioPlayer.play() {
            print(__FUNCTION__, "Failed to play audiofile: \(audioPlayer.url)")
        }
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