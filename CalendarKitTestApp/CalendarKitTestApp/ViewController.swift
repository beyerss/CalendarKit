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
    lazy var inputCalendar: CalendarKit.Calendar = {
        let calendar = CalendarKit.Calendar(configuration: CalendarConfiguration.InputViewConfiguration())
        calendar.delegate = self
        calendar.selectedDate = Date().addingTimeInterval(60*60*24)
        return calendar
    }()
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yy"
        return formatter
    }()
    
    var embeddedCalendar: CalendarKit.Calendar?
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

    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if let calendar = segue.destinationViewController as? CalendarKit.Calendar {
            calendar.delegate = self
            
            // tell the calendar to start with tomorrow selected
            calendar.selectedDate = Date().addingTimeInterval(60*60*24)
        }
    }
    
    @IBAction func showEmbeddedCalendar(_ sender: AnyObject) {
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
                border.backgroundColor = UIColor.lightGray()
                border.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(border)
                
                self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(23)-[border]-(23)-|", options: NSLayoutFormatOptions.alignAllLeft, metrics: nil, views: ["border": border]))
            }
            
            let weekdayHeaderColor = UIColor(red: 157/255, green: 56/255, blue: 155/255, alpha: 1.0)
            
            let dateCellConfiguration = DateCellConfiguration(textStyle: .topCenter(verticalOffset: 8), circleSizeOffset: -7, font: UIFont(name: "AmericanTypewriter-Bold", size: 10)!, backgroundColor: UIColor.white(), disabledBackgroundColor: UIColor.darkGray(), highlightColor: weekdayHeaderColor, textEnabledColor: weekdayHeaderColor, textDisabledColor: UIColor.lightGray(), textHighlightedColor: weekdayHeaderColor.withAlphaComponent(0.6), textSelectedColor: UIColor.white(), heightForDynamicHeightRows: 40.0)
            let monthHeaderConfig = HeaderConfiguration(font: UIFont(name: "AmericanTypewriter-Bold", size: 30)!, textColor: UIColor.lightGray(), backgroundColor: UIColor.purple(), height: 40.0)
            let weekdayHeaderConfig = HeaderConfiguration(font: UIFont(name: "AmericanTypewriter", size: 13)!, textColor: UIColor.lightGray(), backgroundColor: weekdayHeaderColor, height: 20.0)
            
            // Today is the min date, 31 days from now is the max date
            let disabledDates: [Date] = [Date().addingTimeInterval(60 * 60 * 24 * 2), Date().addingTimeInterval(60 * 60 * 24 * 7), Date().addingTimeInterval(60 * 60 * 24 * 8)]
            let logicConfig = CalendarLogicConfiguration(minDate: Date(), maxDate: Date().addingTimeInterval(60 * 60 * 24 * 31), disabledDates: disabledDates, disableWeekends: false)
            
            let config = CalendarConfiguration(displayStyle: .custom, monthFormat: "MMMM yyyy", calendarBackgroundColor: UIColor.lightGray(), hasDynamicHeight: true, spaceBetweenDates: 4.0, monthHeaderConfiguration: monthHeaderConfig, weekdayHeaderConfiguration: weekdayHeaderConfig, dateCellConfiguration: dateCellConfiguration, logicConfiguration: logicConfig)
            embeddedCalendar = CalendarKit.Calendar(configuration: config)
            embeddedCalendar?.delegate = self
            
            guard let calendar = embeddedCalendar else { return }
            calendar.view.translatesAutoresizingMaskIntoConstraints = false
            
            self.addChildViewController(calendar)
            self.view.addSubview(calendar.view)
            
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(25)-[calendar]-(25)-|", options: NSLayoutFormatOptions.alignAllLeft, metrics: nil, views: ["calendar": calendar.view]))
            self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(250)-[calendar]", options: .alignAllBottom, metrics: nil, views: ["calendar": calendar.view]))
            embeddedCalendarHeightConstraint = NSLayoutConstraint(item: calendar.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 277)
            if let constraint = embeddedCalendarHeightConstraint {
                calendar.view.addConstraint(constraint)
                calendar.calendarHeightConstraint = constraint
            }
            
            if let border = border {
                view.addConstraint(NSLayoutConstraint(item: calendar.view, attribute: .top, relatedBy: .equal, toItem: border, attribute: .top, multiplier: 1.0, constant: 2.0))
                view.addConstraint(NSLayoutConstraint(item: border, attribute: .bottom, relatedBy: .equal, toItem: calendar.view, attribute: .bottom, multiplier: 1.0, constant: 2.0))
            }
        }
    }

}

extension ViewController: CalendarDelegate {
    
    func calendar(_ calendar: CalendarKit.Calendar, didSelectDate date: Date) {
        print("Current selected date: \(date)")
        if (calendar != inputCalendar) {
            dismiss(animated: true, completion: nil)
        } else {
            textField.text = dateFormatter.string(from: date)
            textField.resignFirstResponder()
        }
    }
    
    func acessory(forDate date: Date, onCalendar calendar: CalendarKit.Calendar) -> CalendarAccessory? {
        if (calendar != embeddedCalendar) {
            return nil
        }
        
        var accessories = [UIView]()
        if (dateIsDivisibleBy(date: date, divisibleBy: 6)) {
            let accessoryView = UIView()
            accessoryView.backgroundColor = UIColor(red: 91/255, green: 82/255, blue: 174/255, alpha: 1)
            accessoryView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[accessoryView(10)]", options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: ["accessoryView": accessoryView]))
            accessoryView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[accessoryView(10)]", options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: ["accessoryView": accessoryView]))
            accessories.append(accessoryView)
        }
        if (dateIsDivisibleBy(date: date, divisibleBy: 8)) {
            let accessoryView = UIView()
            accessoryView.backgroundColor = UIColor(red: 216/255, green: 143/255, blue: 19/255, alpha: 1)
            accessoryView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[accessoryView(10)]", options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: ["accessoryView": accessoryView]))
            accessoryView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[accessoryView(10)]", options: NSLayoutFormatOptions.alignAllTop, metrics: nil, views: ["accessoryView": accessoryView]))
            accessories.append(accessoryView)
        }
        
        if (accessories.count > 0) {
            let accessoryView = UIView()
            accessoryView.backgroundColor = UIColor.clear()
            
            var previousView: UIView?
            // add all views and fill them vertically
            for aView in accessories {
                aView.translatesAutoresizingMaskIntoConstraints = false
                accessoryView.addSubview(aView)
                accessoryView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[aView]-(0)-|", options: .alignAllRight, metrics: nil, views: ["aView": aView]))
                
                if let previousView = previousView {
                    accessoryView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[aView]-(0)-[previousView]", options: .alignAllTop, metrics: nil, views: ["aView": aView, "previousView": previousView]))
                }
                previousView = aView
            }
            // pin first view to right edge
            accessoryView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[firstView]-(0)-|", options: .alignAllRight, metrics: nil, views: ["firstView": accessories.first!]))
            // pin last view to left edge
            accessoryView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[lastView]", options: .alignAllLeft, metrics: nil, views: ["lastView": accessories.last!]))
            
            return CalendarAccessory(placement: ViewPlacement.bottomRight(verticalOffset: 2, horizontalOffset: 2), view: accessoryView)
        }
        return nil
    }
    
    private func dateIsDivisibleBy(date dateOne: Date, divisibleBy: Int) -> Bool {
        // Get the calendar
        let calendar = Foundation.Calendar.current()
        // Set the componenets for each date
        let firstComponents = calendar.components([.day], from: dateOne)
        
        // compare the day, month and year between the two date componenets
        if (firstComponents.day! % divisibleBy == 0) {
            return true
        }
        
        return false
    }
    
}
