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
        var config = CalendarConfiguration()
        config.displayStyle = .InputView
        config.dateTextStyle = .Center
        
        let calendar = Calendar(configuration: config)
        return calendar
    }()
    
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
