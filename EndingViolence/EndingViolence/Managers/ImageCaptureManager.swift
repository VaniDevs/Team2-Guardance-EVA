//
//  ImageCaptureManager.swift
//  EndingViolence
//
//  Created by Steven Thompson on 2016-03-05.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import UIKit
import AVFoundation

class ImageCaptureManager: NSObject {
    let session: AVCaptureSession = AVCaptureSession()
    var device: AVCaptureDevice?
    var input: AVCaptureDeviceInput?
    var sessionQueue: dispatch_queue_t?
    
    private func setup() {
        switch AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) {
        case .Authorized:
            NSLog("AVCaptureDevice authorization Authorized")
            finishSetup()
        case .Denied:
            NSLog("AVCaptureDevice authorization Denied")
        case .NotDetermined:
            NSLog("AVCaptureDevice authorization NotDetermined")
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { (success) -> Void in
                self.finishSetup()
            })
        case .Restricted:
            NSLog("AVCaptureDevice authorization Restricted")
        }
    }
    
    private func finishSetup() {
        device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
            session.beginConfiguration()
            input = try AVCaptureDeviceInput.init(device: device)
            session.addInput(input)
            session.commitConfiguration()
            
            NSLog("ImageCaptureManager started capturing images")
        } catch let error as NSError { NSLog("\(error)") }
    }
    
    func begin() {
        setup()
        session.startRunning()
        
        
    }
    
    func stop() {
        session.stopRunning()
    }
}
