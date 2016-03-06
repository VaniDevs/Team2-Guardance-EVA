//
//  Utils.swift
//  EndingViolence
//
//  Created by Paul Wadsworth on 05/03/2016.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import Foundation

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