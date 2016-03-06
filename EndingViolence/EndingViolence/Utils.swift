//
//  Utils.swift
//  EndingViolence
//
//  Created by Paul Wadsworth on 05/03/2016.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import Foundation
import UIKit

func dispatchAsync(block: () -> ()) {
    dispatchAsyncOn(dispatch_get_main_queue()) {
        block()
    }
}

func dispatchAsyncAfter(timeInSecs: Double, block: () -> ()) {
    dispatchAsyncAfterOn(dispatch_get_main_queue(), timeInSecs: timeInSecs, block: block)
}

func dispatchAsyncOn(queue: dispatch_queue_t, block: ()->()) {
    dispatch_async(queue, block)
}

func dispatchAsyncAfterOn(queue: dispatch_queue_t, timeInSecs: Double, block: () -> ()) {
    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(timeInSecs * Double(NSEC_PER_SEC)))
    dispatch_after(delayTime, queue, block)
}


func mainBundleURL() -> NSURL {
    return NSBundle.mainBundle().bundleURL
}

func mainBundlePath() -> String {
    return mainBundleURL().path!
}

func mainBundleName() -> String {
    return NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleNameKey as String) as! String
}

func documentPath() -> String {
    return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
}

func tmpPath() -> String {
    return NSTemporaryDirectory()
}
/*
tmpPath()

func saveImage(image: UIImage, ToTmpDirWithName name) {
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:name];
        [fileManager createFileAtPath:fullPath contents:data attributes:nil];
}
*/

extension UIViewController {
    @IBAction func callDismissOnPresentingController() {
        if let vc = presentingViewController {
            vc.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}