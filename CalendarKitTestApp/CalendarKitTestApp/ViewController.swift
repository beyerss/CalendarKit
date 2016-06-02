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
        calendar.delegate = self
        calendar.selectedDate = NSDate().dateByAddingTimeInterval(60*60*24)
        return calendar
    }()
    lazy var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "M/d/yy"
        return formatter
    }()
    
    var embeddedCalendar: Calendar?
    var embeddedCalendarHeightConstraint: NSLayoutConstraint?
    var border: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
                border.backgroundColor = UIColor.lightGrayColor()
                border.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(border)
                
                self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-(23)-[border]-(23)-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["border": border]))
            }
            
            let weekdayHeaderColor = UIColor(red: 157/255, green: 56/255, blue: 155/255, alpha: 1.0)
            
            let dateCellConfiguration = DateCellConfiguration(textStyle: .TopCenter(verticalOffset: 8), circleSizeOffset: -7, font: UIFont(name: "AmericanTypewriter-Bold", size: 10)!, backgroundColor: UIColor.whiteColor(), disabledBackgroundColor: UIColor.darkGrayColor(), highlightColor: weekdayHeaderColor, textEnabledColor: weekdayHeaderColor, textDisabledColor: UIColor.lightGrayColor(), textHighlightedColor: weekdayHeaderColor.colorWithAlphaComponent(0.6), textSelectedColor: UIColor.whiteColor(), heightForDynamicHeightRows: 40.0)
            let monthHeaderConfig = HeaderConfiguration(font: UIFont(name: "AmericanTypewriter-Bold", size: 30)!, textColor: UIColor.lightGrayColor(), backgroundColor: UIColor.purpleColor(), height: 40.0)
            let weekdayHeaderConfig = HeaderConfiguration(font: UIFont(name: "AmericanTypewriter", size: 13)!, textColor: UIColor.lightGrayColor(), backgroundColor: weekdayHeaderColor, height: 20.0)
            
            // Today is the min date, 31 days from now is the max date
            let disabledDates: [NSDate] = [NSDate().dateByAddingTimeInterval(60 * 60 * 24 * 2), NSDate().dateByAddingTimeInterval(60 * 60 * 24 * 7), NSDate().dateByAddingTimeInterval(60 * 60 * 24 * 8)]
            let logicConfig = CalendarLogicConfiguration(minDate: NSDate(), maxDate: NSDate().dateByAddingTimeInterval(60 * 60 * 24 * 31), disabledDates: disabledDates, disableWeekends: false)
            
            let config = CalendarConfiguration(displayStyle: .Custom, monthFormat: "MMMM yyyy", calendarBackgroundColor: UIColor.lightGrayColor(), hasDynamicHeight: true, spaceBetweenDates: 4.0, monthHeaderConfiguration: monthHeaderConfig, weekdayHeaderConfiguration: weekdayHeaderConfig, dateCellConfiguration: dateCellConfiguration, logicConfiguration: logicConfig)
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
            textField.text = dateFormatter.stringFromDate(date)
            textField.resignFirstResponder()
        }
    }
    
    func acessory(forDate date: NSDate, onCalendar calendar: Calendar) -> CalendarAccessory? {
        if (calendar != embeddedCalendar) {
            return nil
        }
        
        var accessories = [UIView]()
        if (dateIsDivisibleBy(date: date, divisibleBy: 6)) {
            let accessoryView = UIView()
            accessoryView.backgroundColor = UIColor(red: 91/255, green: 82/255, blue: 174/255, alpha: 1)
            accessoryView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[accessoryView(10)]", options: NSLayoutFormatOptions.AlignAllTop, metrics: nil, views: ["accessoryView": accessoryView]))
            accessoryView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[accessoryView(10)]", options: NSLayoutFormatOptions.AlignAllTop, metrics: nil, views: ["accessoryView": accessoryView]))
            accessories.append(accessoryView)
        }
        if (dateIsDivisibleBy(date: date, divisibleBy: 8)) {
            let accessoryView = UIView()
            accessoryView.backgroundColor = UIColor(red: 216/255, green: 143/255, blue: 19/255, alpha: 1)
            accessoryView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[accessoryView(10)]", options: NSLayoutFormatOptions.AlignAllTop, metrics: nil, views: ["accessoryView": accessoryView]))
            accessoryView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[accessoryView(10)]", options: NSLayoutFormatOptions.AlignAllTop, metrics: nil, views: ["accessoryView": accessoryView]))
            accessories.append(accessoryView)
        }
        
        if (accessories.count > 0) {
            let accessoryView = UIView()
            accessoryView.backgroundColor = UIColor.clearColor()
            
            var previousView: UIView?
            // add all views and fill them vertically
            for aView in accessories {
                aView.translatesAutoresizingMaskIntoConstraints = false
                accessoryView.addSubview(aView)
                accessoryView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[aView]-(0)-|", options: .AlignAllRight, metrics: nil, views: ["aView": aView]))
                
                if let previousView = previousView {
                    accessoryView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[aView]-(0)-[previousView]", options: .AlignAllTop, metrics: nil, views: ["aView": aView, "previousView": previousView]))
                }
                previousView = aView
            }
            // pin first view to right edge
            accessoryView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[firstView]-(0)-|", options: .AlignAllRight, metrics: nil, views: ["firstView": accessories.first!]))
            // pin last view to left edge
            accessoryView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-(0)-[lastView]", options: .AlignAllLeft, metrics: nil, views: ["lastView": accessories.last!]))
            
            return CalendarAccessory(placement: ViewPlacement.BottomRight(verticalOffset: 2, horizontalOffset: 2), view: accessoryView)
        }
        return nil
    }
    
    private func dateIsDivisibleBy(date dateOne: NSDate, divisibleBy: Int) -> Bool {
        // Get the calendar
        let calendar = NSCalendar.currentCalendar()
        // Set the componenets for each date
        let firstComponents = calendar.components([.Day], fromDate: dateOne)
        
        // compare the day, month and year between the two date componenets
        if (firstComponents.day % divisibleBy == 0) {
            return true
        }
        
        return false
    }
    
}
