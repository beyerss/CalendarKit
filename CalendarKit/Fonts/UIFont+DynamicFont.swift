//
//  UIFont+DynamicFont.swift
//  CalendarKit
//
//  Created by Steven Beyers on 4/30/16.
//  Copyright © 2016 Beyers Apps, LLC. All rights reserved.
//

import Foundation

/**
 Extension on UIFont used for supporting dynamic font. All fonts should be set using this class.
 */
extension UIFont {
    
    /**
     Calculates the font and size that should be used for the Month header label. The font will default to the system font in the event that the specified font does not exist on the device.
     
     @return The font to display
    */
    class func preferredMonthHeaderFont() -> UIFont {
        var fontSize: CGFloat
        let contentSize = UIApplication.shared().preferredContentSizeCategory
        
        switch contentSize {
        case UIContentSizeCategoryExtraSmall:
            fontSize = 19
        case UIContentSizeCategorySmall:
            fontSize = 20
        case UIContentSizeCategoryMedium:
            fontSize = 21
        case UIContentSizeCategoryExtraLarge:
            fontSize = 23
        case UIContentSizeCategoryExtraExtraLarge:
            fontSize = 24
        case UIContentSizeCategoryExtraExtraExtraLarge:
            fontSize = 25
        default:
            fontSize = 22
        }
        
        if let font = UIFont(name: "AvenirNext-Medium", size: fontSize) {
            return font
        }
        
        // if the font we create doesn't work lets return a better font
        return UIFont.systemFont(ofSize: fontSize)
    }
    
    /**
     Calculates the font and size that should be used for the Month header label when being used as an InputView for a UITextField. The font will default to the system font in the event that the specified font does not exist on the device.
     
     @return The font to display
     */
    class func preferredInputViewMonthHeaderFont() -> UIFont {
        var fontSize: CGFloat
        let contentSize = UIApplication.shared().preferredContentSizeCategory
        
        switch contentSize {
        case UIContentSizeCategoryExtraSmall:
            fontSize = 15
        case UIContentSizeCategorySmall:
            fontSize = 16
        case UIContentSizeCategoryMedium:
            fontSize = 17
        case UIContentSizeCategoryExtraLarge:
            fontSize = 19
        case UIContentSizeCategoryExtraExtraLarge:
            fontSize = 20
        case UIContentSizeCategoryExtraExtraExtraLarge:
            fontSize = 21
        default:
            fontSize = 18
        }
        
        if let font = UIFont(name: "AvenirNext-Medium", size: fontSize) {
            return font
        }
        
        // if the font we create doesn't work lets return a better font
        return UIFont.systemFont(ofSize: fontSize)
    }
    
    /**
     Calculates the font and size that should be used for the Weekday header label. The font will default to the system font in the event that the specified font does not exist on the device.
     
     @return The font to display
     */
    class func preferredWeekdayHeaderFont() -> UIFont {
        var fontSize: CGFloat
        let contentSize = UIApplication.shared().preferredContentSizeCategory
        
        switch contentSize {
        case UIContentSizeCategoryExtraSmall:
            fontSize = 14
        case UIContentSizeCategorySmall:
            fontSize = 15
        case UIContentSizeCategoryMedium:
            fontSize = 16
        case UIContentSizeCategoryExtraLarge:
            fontSize = 18
        case UIContentSizeCategoryExtraExtraLarge:
            fontSize = 19
        case UIContentSizeCategoryExtraExtraExtraLarge:
            fontSize = 20
        default:
            fontSize = 17
        }
        
        if let font = UIFont(name: "AvenirNext-Medium", size: fontSize) {
            return font
        }
        
        // if the font we create doesn't work lets return a better font
        return UIFont.systemFont(ofSize: fontSize)
    }
    
    /**
     Calculates the font and size that should be used for the Weekday header label when being used as an InputView for a UITextField. The font will default to the system font in the event that the specified font does not exist on the device.
     
     @return The font to display
     */
    class func preferredInputViewWeekdayHeaderFont() -> UIFont {
        var fontSize: CGFloat
        let contentSize = UIApplication.shared().preferredContentSizeCategory
        
        switch contentSize {
        case UIContentSizeCategoryExtraSmall:
            fontSize = 11
        case UIContentSizeCategorySmall:
            fontSize = 12
        case UIContentSizeCategoryMedium:
            fontSize = 13
        case UIContentSizeCategoryExtraLarge:
            fontSize = 15
        case UIContentSizeCategoryExtraExtraLarge:
            fontSize = 16
        case UIContentSizeCategoryExtraExtraExtraLarge:
            fontSize = 17
        default:
            fontSize = 14
        }
        
        if let font = UIFont(name: "AvenirNext-Medium", size: fontSize) {
            return font
        }
        
        // if the font we create doesn't work lets return a better font
        return UIFont.systemFont(ofSize: fontSize)
    }
    
    /**
     Calculates the font and size that should be used for the date cells. The font will default to the system font in the event that the specified font does not exist on the device.
     
     @return The font to display
     */
    class func preferredDateFont() -> UIFont {
        var fontSize: CGFloat
        let contentSize = UIApplication.shared().preferredContentSizeCategory
        
        switch contentSize {
        case UIContentSizeCategoryExtraSmall:
            fontSize = 14
        case UIContentSizeCategorySmall:
            fontSize = 15
        case UIContentSizeCategoryMedium:
            fontSize = 16
        case UIContentSizeCategoryExtraLarge:
            fontSize = 18
        case UIContentSizeCategoryExtraExtraLarge:
            fontSize = 19
        case UIContentSizeCategoryExtraExtraExtraLarge:
            fontSize = 20
        default:
            fontSize = 17
        }
        
        if let font = UIFont(name: "AvenirNext-Medium", size: fontSize) {
            return font
        }
        
        // if the font we create doesn't work lets return a better font
        return UIFont.systemFont(ofSize: fontSize)
    }
    
    /**
     Calculates the font and size that should be used for the date cells when being used as an InputView for a UITextField. The font will default to the system font in the event that the specified font does not exist on the device.
     
     @return The font to display
     */
    class func preferredInputViewDateFont() -> UIFont {
        var fontSize: CGFloat
        let contentSize = UIApplication.shared().preferredContentSizeCategory
        
        switch contentSize {
        case UIContentSizeCategoryExtraSmall:
            fontSize = 12
        case UIContentSizeCategorySmall:
            fontSize = 13
        case UIContentSizeCategoryMedium:
            fontSize = 14
        case UIContentSizeCategoryExtraLarge:
            fontSize = 16
        case UIContentSizeCategoryExtraExtraLarge:
            fontSize = 17
        case UIContentSizeCategoryExtraExtraExtraLarge:
            fontSize = 18
        default:
            fontSize = 15
        }
        
        if let font = UIFont(name: "AvenirNext-Medium", size: fontSize) {
            return font
        }
        
        // if the font we create doesn't work lets return a better font
        return UIFont.systemFont(ofSize: fontSize)
    }
    
}
