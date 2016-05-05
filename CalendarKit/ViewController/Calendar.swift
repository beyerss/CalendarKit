//
//  Calendar.swift
//  CalendarKit
//
//  Created by Steven Beyers on 5/23/15.
//  Copyright (c) 2015 Beyers Apps, LLC. All rights reserved.
//

import UIKit

public class Calendar: UIViewController {
    @IBOutlet private weak var calendarCollectionView: UICollectionView!
    
    // The months that are currently available
    private var monthsShowing = Array<Month>()
    // The month currently showing
    private var currentMonth = Month(monthDate: NSDate())
    
    // The date that has been selected
    public var selectedDate: NSDate?
    
    // The delegate to notify of events
    public var delegate: CalendarDelegate?
    // The configuration for the calendar
    var configuration = CalendarConfiguration.FullScreenConfiguration() {
        didSet {
            if let myView = view {
                myView.backgroundColor = configuration.calendarBackgroundColor
            }
        }
    }
    
    public init(configuration: CalendarConfiguration? = nil) {
        super.init(nibName: "Calendar", bundle: NSBundle(identifier: "com.beyersapps.CalendarKit"))
        
        // set the configuration to the one specified
        if let config = configuration {
            self.configuration = config
        }
    }

    public required init(coder aDecoder: NSCoder) {
        super.init(nibName: "Calendar", bundle: NSBundle(identifier: "com.beyersapps.CalendarKit"))
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // set the background color
        view.backgroundColor = configuration.calendarBackgroundColor
        
        // register cell
        let bundle = NSBundle(identifier: "com.beyersapps.CalendarKit")
        calendarCollectionView.registerNib(UINib(nibName: "CalendarMonth", bundle: bundle), forCellWithReuseIdentifier: "monthCell")
        
        // Set up data to start at the date 2 months ago
        rebuildMonths(currentMonthOnly: true)
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // reload the data whenever the view appears
        self.calendarCollectionView.reloadData()
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // rebuild the month array when the view appears
        rebuildMonths()
        
        // reload data and make sure we are at the center month so that we can scroll both ways
        calendarCollectionView.reloadData()
        calendarCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 2), atScrollPosition: .Left, animated: false)
    }
    
    /**
     Rebuilds the month array with the current month being in the center and two months on the left plus another two months on the right so that we can scroll both directions.
    */
    private func rebuildMonths(currentMonthOnly currentOnly: Bool = false) {
        monthsShowing = Array<Month>()
        
        if (currentOnly) {
            // If we only want the current month than we can only show one month at a time
            let tempMonth = currentMonth
            currentMonth = tempMonth
            monthsShowing.append(currentMonth)
        } else {
            // If we want to scroll between months then put two months on both sides of the current month
            monthsShowing.append(Month(otherMonth: currentMonth, offsetMonths: -2))
            monthsShowing.append(Month(otherMonth: currentMonth, offsetMonths: -1))
            monthsShowing.append(currentMonth)
            monthsShowing.append(Month(otherMonth: currentMonth, offsetMonths: 1))
            monthsShowing.append(Month(otherMonth: currentMonth, offsetMonths: 2))
        }
    }

}

 extension Calendar: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    public func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        // Keep track of the month being displayed
        let month = monthsShowing[indexPath.section]
        if (month != currentMonth) {
            currentMonth = month
        }
    }
    
    /**
     Handle scrolling ending
    */
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // if we are not on the center section
        let offset = scrollView.contentOffset.x
        if (scrollView.contentOffset.x != self.view.frame.width * 2) {
            // reset the position of the collection view to re-center
            //            resetPosition()
            
            if (offset == 0) {
                currentMonth = monthsShowing[0]
            } else if (offset == view.frame.width) {
                currentMonth = monthsShowing[1]
            } else if (offset == view.frame.width * 2) {
                currentMonth = monthsShowing[2]
            } else if (offset == view.frame.width * 3) {
                currentMonth = monthsShowing[3]
            } else {
                currentMonth = monthsShowing[4]
            }
            
            // notify the delegate that we changed months
            delegate?.calendar?(self, didScrollToDate: currentMonth.date, withNumberOfWeeks: currentMonth.weeksInMonth())

            // rebuild the months so that the new month is in the middle
            rebuildMonths()
            
            // reload data and move to the center of the scroll view
            calendarCollectionView.reloadData()
            calendarCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 2), atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
        } else {
            // If we are still in the center of the scroll view then we didn't change months
            if (currentMonth != monthsShowing[2]) {
                currentMonth = monthsShowing[2]
            }
        }
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        // This should fill the entire frame of the collection view
        return calendarCollectionView.frame.size
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // Nothing happens here b/c we can only select individual cells
        collectionView.deselectItemAtIndexPath(indexPath, animated: false)
    }
    
}

extension Calendar: UICollectionViewDataSource {
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // We are showing one CalendarMonth cell for each section
        return 1
    }
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // Show one section for each month
        return monthsShowing.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // Get the month cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("monthCell", forIndexPath: indexPath)
        if let month = cell as? CalendarMonth {
            // let the monthCell know that I own it
            month.containingCalendar = self
            month.monthToDisplay = monthsShowing[indexPath.section]
            month.backgroundColor = configuration.calendarBackgroundColor
        }
     
        return cell
    }
}
