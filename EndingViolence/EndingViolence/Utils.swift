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

func clamp<T : Comparable>(value: T, _ minValue: T, _ maxValue: T) -> T {
    return max(min(value, maxValue), minValue)
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

func saveDataToPath(data: NSData, path: String) -> Bool {

    let fileMgr = NSFileManager.defaultManager()

    let succeeded = fileMgr.createFileAtPath(path, contents: data, attributes: nil)
    if succeeded {
        print("Succeeded in saving: \(path)")
    } else {
        print("FAILED to save: \(path)")
    }
    return succeeded
}

func fullPathForFilenameInTmpDir(filename: String) -> String {
    let tmp = tmpPath()
    return (tmp as NSString).stringByAppendingPathComponent(filename)
}


extension UIViewController {
    @IBAction func callDismissOnPresentingController() {
        if let vc = presentingViewController {
            vc.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}