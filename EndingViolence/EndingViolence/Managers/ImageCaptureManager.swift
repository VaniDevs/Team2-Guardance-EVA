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
    var session: AVCaptureSession!
    var device: AVCaptureDevice?
    var input: AVCaptureDeviceInput?
    var output: AVCaptureStillImageOutput?
    var sessionQueue: dispatch_queue_t?
    
    var currentImage: UIImage?
    
    func setup() {
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
            session = AVCaptureSession()
            session.beginConfiguration()
            input = try AVCaptureDeviceInput.init(device: device)
            session.addInput(input)
            output = AVCaptureStillImageOutput()
            session.addOutput(output)
            session.commitConfiguration()
        } catch let error as NSError { NSLog("\(error)") }
    }
    
    func begin() {
        session!.startRunning()
    }
    
    func stop() {
        session!.stopRunning()
    }
    
    func captureImage(completion: (image: UIImage) -> Void) {
        let connection = output?.connectionWithMediaType(AVMediaTypeVideo)
        output?.captureStillImageAsynchronouslyFromConnection(connection, completionHandler: { (buffer, error) in
            if let buff = buffer {
                let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buff)
                if let image = UIImage(data: data) {
                    completion(image: image)
                }
            }
        })
    }
}
