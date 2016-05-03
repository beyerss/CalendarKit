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
        } else {
            let config = CalendarConfiguration(displayStyle: .Custom, dateTextStyle: .TopLeft(verticalOffset: 6, horizontalOffset: 8), dateCircleSizeOffset: -7, monthHeaderFont: UIFont(name: "AmericanTypewriter-Bold", size: 30)!, dayHeaderFont: UIFont(name: "AmericanTypewriter", size: 13)!, dateLabelFont: UIFont(name: "AmericanTypewriter-Bold", size: 10)!)
            embeddedCalendar = Calendar(configuration: config)
            
            guard let calendar = embeddedCalendar else { return }
            calendar.view.translatesAutoresizingMaskIntoConstraints = false
            
            self.addChildViewController(calendar)
            self.view.addSubview(calendar.view)
            
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-(25)-[calendar]-(25)-|", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: ["calendar": calendar.view]))
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[calendar(300)]-(25)-|", options: .AlignAllBottom, metrics: nil, views: ["calendar": calendar.view]))
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
    }
    
}
