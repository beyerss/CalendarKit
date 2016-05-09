//
//  ViewController.swift
//  CalendarKitTestApp
//
//  Created by Steven Beyers on 5/23/15.
//  Copyright (c) 2015 Beyers Apps, LLC. All rights reserved.
//

import UIKit
import CalendarKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    lazy var inputCalendar: Calendar = {
        let calendar = Calendar(configuration: CalendarConfiguration.InputViewConfiguration())
        return calendar
    }()
    
    var embeddedCalendar: Calendar?
    var embeddedCalendarHeightConstraint: NSLayoutConstraint?
    var border: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        inputCalendar.delegate = self
        inputCalendar.selectedDate = NSDate().dateByAddingTimeInterval(60*60*24)
        
        textField.inputView = inputCalendar.view
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let calendar = segue.destinationViewController as? Calendar {
            calendar.delegate = self
            
            // tell the calendar to start with tomorrow selected
            calendar.selectedDate = NSDate().dateByAddingTimeInterval(60*60*24)
        }
    }
    
    @IBAction func showEmbeddedCalendar(sender: AnyObject) {
        if let calendar = embeddedCalendar {
            calendar.view.removeFromSuperview()
            calendar.removeFromParentViewController()
            embeddedCalendar = nil
            
            if let border = border {
                border.removeFromSuperview()
                self.border = nil
            }
        } else {
            
            // Create a view that will be used as a border around the calendar
            border = UIView()
            if let border = border {
                border.backgroundColor = UIColor.redColor()
                border.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(border)
                
                self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-(23)-[border]-(23)-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["border": border]))
            }
            
            let weekdayHeaderColor = UIColor(red: 157/255, green: 56/255, blue: 155/255, alpha: 1.0)
            let config = CalendarConfiguration(displayStyle: .Custom, dateTextStyle: .TopCenter(verticalOffset: 8), dateCircleSizeOffset: -7, monthHeaderFont: UIFont(name: "AmericanTypewriter-Bold", size: 30)!, dayHeaderFont: UIFont(name: "AmericanTypewriter", size: 13)!, dateLabelFont: UIFont(name: "AmericanTypewriter-Bold", size: 10)!, headerBackgroundColor: UIColor.purpleColor(), weekdayHeaderBackgroundColor: weekdayHeaderColor, dateHighlightColor: weekdayHeaderColor, dateBackgroundColor: UIColor.whiteColor(), dateDisabledBackgroundColor: UIColor.darkGrayColor(), calendarBackgroundColor: UIColor.lightGrayColor(), dateTextEnabledColor: weekdayHeaderColor, dateTextDisabledColor: UIColor.lightGrayColor(), dateTextSelectedColor: UIColor.whiteColor(), dateTextHighlightedColor: weekdayHeaderColor.colorWithAlphaComponent(0.6), monthHeaderTextColor: UIColor.lightGrayColor(), weekdayHeaderTextColor: UIColor.lightGrayColor(), monthFormat: "MMMM yyyy", monthHeaderHeight: 40.0, weekdayHeaderHeight: 20.0, hasDynamicHeight: true, heightForDynamicHeightRows: 40, spaceBetweenDates: 4.0)
            embeddedCalendar = Calendar(configuration: config)
            embeddedCalendar?.delegate = self
            
            guard let calendar = embeddedCalendar else { return }
            calendar.view.translatesAutoresizingMaskIntoConstraints = false
            
            self.addChildViewController(calendar)
            self.view.addSubview(calendar.view)
            
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-(25)-[calendar]-(25)-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["calendar": calendar.view]))
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(250)-[calendar]", options: .AlignAllBottom, metrics: nil, views: ["calendar": calendar.view]))
            embeddedCalendarHeightConstraint = NSLayoutConstraint(item: calendar.view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 277)
            if let constraint = embeddedCalendarHeightConstraint {
                calendar.view.addConstraint(constraint)
                calendar.calendarHeightConstraint = constraint
            }
            
            if let border = border {
                view.addConstraint(NSLayoutConstraint(item: calendar.view, attribute: .Top, relatedBy: .Equal, toItem: border, attribute: .Top, multiplier: 1.0, constant: 2.0))
                view.addConstraint(NSLayoutConstraint(item: border, attribute: .Bottom, relatedBy: .Equal, toItem: calendar.view, attribute: .Bottom, multiplier: 1.0, constant: 2.0))
            }
        }
    }

}

extension ViewController: CalendarDelegate {
    
    func calendar(calendar: Calendar, didSelectDate date: NSDate) {
        print("Current selected date: \(date)")
        if (calendar != inputCalendar) {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            textField.resignFirstResponder()
        }
    }
    
    func calendar(calendar: Calendar, didScrollToDate date: NSDate, withNumberOfWeeks weeks: Int) {
        print("Scrolled to date (\(date)) with \(weeks) weeks")
        if (calendar == embeddedCalendar) {
            
        }
    }
    
}
