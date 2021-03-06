//
//  CalendarDesignKit.swift
//  CalendarKit
//
//  Created by Steven Beyers on 5/4/16.
//  Copyright (c) 2016 Beyers Apps, LLC. All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//



import UIKit

public class CalendarDesignKit : NSObject {

    //// Cache

    private struct Cache {
        static let dateBackgroundColor: UIColor = UIColor(red: 0.967, green: 0.967, blue: 0.967, alpha: 1.000)
        static let calendarBackgroundColor: UIColor = UIColor(red: 0.460, green: 0.460, blue: 0.460, alpha: 1.000)
        static let calendarDisabledDateColor: UIColor = UIColor(red: 0.816, green: 0.816, blue: 0.816, alpha: 1.000)
        static let calendarDateColor: UIColor = UIColor(red: 0.545, green: 0.800, blue: 0.764, alpha: 1.000)
    }

    //// Colors

    public class var dateBackgroundColor: UIColor { return Cache.dateBackgroundColor }
    public class var calendarBackgroundColor: UIColor { return Cache.calendarBackgroundColor }
    public class var calendarDisabledDateColor: UIColor { return Cache.calendarDisabledDateColor }
    public class var calendarDateColor: UIColor { return Cache.calendarDateColor }

    //// Drawing Methods

    public class func drawCircleFilledBackground(frame frame: CGRect = CGRect(x: 0, y: 0, width: 58, height: 58), dateCircleColor: UIColor = UIColor(red: 0.545, green: 0.800, blue: 0.764, alpha: 1.000)) {

        //// DateCircle Drawing
        let dateCirclePath = UIBezierPath(ovalInRect: CGRect(x: frame.minX + 8, y: frame.minY + 8, width: frame.width - 16, height: frame.height - 16))
        dateCircleColor.setFill()
        dateCirclePath.fill()
        dateCircleColor.setStroke()
        dateCirclePath.lineWidth = 3
        dateCirclePath.stroke()
    }

    public class func drawCircleBackground(frame frame: CGRect = CGRect(x: 0, y: 0, width: 58, height: 58), dateCircleColor: UIColor = UIColor(red: 0.545, green: 0.800, blue: 0.764, alpha: 1.000)) {

        //// DateCircle Drawing
        let dateCirclePath = UIBezierPath(ovalInRect: CGRect(x: frame.minX + 8, y: frame.minY + 8, width: frame.width - 16, height: frame.height - 16))
        dateCircleColor.setStroke()
        dateCirclePath.lineWidth = 3
        dateCirclePath.stroke()
    }

}
