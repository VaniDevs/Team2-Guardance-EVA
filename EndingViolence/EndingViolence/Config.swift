//
//  Config.swift
//  EndingViolence
//
//  Created by Paul Wadsworth on 05/03/2016.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import UIKit

// Convenience class method on UIColor for using hex strings
extension UIColor {
    class func evaRed() -> UIColor {
        return UIColor.colorWithHexString("7F1706")!
    }

    class func evaOrangeAlert() -> UIColor {
        return UIColor.colorWithHexString("C4630E")!
    }

    class func evaBackgroundGrey() -> UIColor {
        return UIColor.colorWithHexString("f2f4f7")!
    }

    class func evaYellowDull() -> UIColor {
        return UIColor.colorWithHexString("B09405")!
    }

    class func evaYellowBright() -> UIColor {
        return UIColor.colorWithHexString("D49B15")!
    }

    class func colorWithHexString(hexString: String, alpha: CGFloat = 1.0) -> UIColor? {
        var cleanedString = hexString
        
        if cleanedString.characters.first == "#" { // Remove leading # characters
            cleanedString.removeAtIndex(hexString.startIndex)
        }
        
        if cleanedString.characters.count == 3 { // Double up if 3 characters long
            cleanedString = String(cleanedString.characters.reduce([]) { xs, x in return xs + [x] + [x] })
        }
        
        if cleanedString.characters.count != 6 {
            return nil
        }
        
        var rgbValue: UInt32 = 0
        let scanner = NSScanner(string: cleanedString)
        scanner.scanHexInt(&rgbValue)
        
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0xFF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0xFF) / 255.0, alpha: alpha)
    }
}