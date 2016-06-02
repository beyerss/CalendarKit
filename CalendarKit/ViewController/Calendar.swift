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
    // The position of the current month in the scroll view
    private var currentMonthPosition: Int = 0
    
    // The date that has been selected
    public var selectedDate: NSDate?
    
    // The delegate to notify of events
    public var delegate: CalendarDelegate?
    // The configuration for the calendar
    private(set) public var configuration = CalendarConfiguration.FullScreenConfiguration() {
        didSet {
            if let myView = view {
                myView.backgroundColor = configuration.backgroundColor
            }
            if let collection = calendarCollectionView {
                collection.backgroundColor = configuration.backgroundColor
            }
        }
    }
    
    /// The constraint that limits the height of the calendar. This is used when a dynamic calendar height is desired.
    public var calendarHeightConstraint: NSLayoutConstraint?
    
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
        // set the month format
        currentMonth.useMonthFormat(configuration.monthFormat)
        
        // set the background color
        view.backgroundColor = configuration.backgroundColor
        calendarCollectionView.backgroundColor = configuration.backgroundColor
        
        // register cell
        let bundle = NSBundle(identifier: "com.beyersapps.CalendarKit")
        calendarCollectionView.registerNib(UINib(nibName: "CalendarMonth", bundle: bundle), forCellWithReuseIdentifier: "monthCell")
        
        // Set up data to start at the date 2 months ago
        rebuildMonths(currentMonthOnly: true)
        
        // tell the delegate what month I'm on
        delegate?.calendar(self, didScrollToDate: currentMonth.date, withNumberOfWeeks: currentMonth.weeksInMonth())
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // fix the calendar height
        updateCalendarHeight()
        
        // reload the data whenever the view appears
        self.calendarCollectionView.reloadData()
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // rebuild the month array when the view appears
        rebuildMonths()
        
        // reload data and make sure we are at the center month so that we can scroll both ways
        calendarCollectionView.reloadData()
        calendarCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: currentMonthPosition), atScrollPosition: .Left, animated: false)
    }
    
    public override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
//        coordinator.animateAlongsideTransition({ (context: UIViewControllerTransitionCoordinatorContext) in
//            // do nothing
//        }) { [weak self](context: UIViewControllerTransitionCoordinatorContext) in
//            self?.calendarCollectionView.collectionViewLayout.invalidateLayout()
//            self?.view.setNeedsDisplay()
//                self?.calendarCollectionView.reloadData()
//        }
        coordinator.animateAlongsideTransition({ [weak self](context) -> Void in
            
            self?.calendarCollectionView.collectionViewLayout.invalidateLayout()
            
            }, completion: { [weak self](context) -> Void in
                guard let weakSelf = self else { return }
                
                weakSelf.calendarCollectionView.reloadData()
                weakSelf.calendarCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: weakSelf.currentMonthPosition), atScrollPosition: .Left, animated: false)
                
        })
    }

    /**
     Updates the height of the calendar if the height is supposed to be dynamic
    */
    private func updateCalendarHeight() {
        if (configuration.dynamicHeight) {
            let weeks = CGFloat(currentMonth.weeksInMonth())
            let totalCellHeight = weeks * configuration.dateCellConfiguration.heightForDynamicHeightRows
            let totalSpacerheight = (weeks - 1) * configuration.spaceBetweenDates
            let monthHeaderHeight = configuration.monthHeaderConfiguration.height
            let weekdayHeaderHeight = configuration.weekdayHeaderConfiguration.height
            let padding: CGFloat = 1
            
            let desiredHeight = totalCellHeight + totalSpacerheight + monthHeaderHeight + weekdayHeaderHeight + padding
            
            if let constraint = calendarHeightConstraint where constraint.constant != desiredHeight {
                if (constraint.constant > desiredHeight) {
                    calendarCollectionView.collectionViewLayout.invalidateLayout()
                }
                
                constraint.constant = desiredHeight
                UIView.animateWithDuration(0.5, animations: {[weak self]() in
                    // call layout if needed on superview so it animates and related constraints
                    self?.view.superview?.layoutIfNeeded()
                    // animate calendar constraints
                    self?.view.layoutIfNeeded()
                    }, completion: { (finished) in
                })
            }
        }
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
            
            // reset the currentMonthPostion before rebuilding array
            currentMonthPosition = 0
            
            if let twoMonthsBack = getFirstDayOfMonthOffsetFromCurrentMonth(-2) where isAfterMinDate(twoMonthsBack) {
                monthsShowing.append(Month(monthDate: twoMonthsBack))
                currentMonthPosition += 1
            }
            if let oneMonthsBack = getFirstDayOfMonthOffsetFromCurrentMonth(-1) where isAfterMinDate(oneMonthsBack) {
                monthsShowing.append(Month(monthDate: oneMonthsBack))
                currentMonthPosition += 1
            }
            monthsShowing.append(currentMonth)
            if let oneMonthForward = getFirstDayOfMonthOffsetFromCurrentMonth(1) where isBeforeMaxDate(oneMonthForward) {
                monthsShowing.append(Month(monthDate: oneMonthForward))
            }
            if let twoMonthForward = getFirstDayOfMonthOffsetFromCurrentMonth(2) where isBeforeMaxDate(twoMonthForward) {
                monthsShowing.append(Month(monthDate: twoMonthForward))
            }
        }
    }
    
    private func getFirstDayOfMonthOffsetFromCurrentMonth(offset: Int) -> NSDate? {
        let calendar = NSCalendar.currentCalendar()
        var date = calendar.dateByAddingUnit(.Month, value: offset, toDate: currentMonth.date, options: [])!
        
        return date
    }
    
    private func isAfterMinDate(date: NSDate) -> Bool {
        if let minDate = configuration.logicConfiguration?.minDate {
            return (NSCalendar.currentCalendar().compareDate(minDate, toDate: date, toUnitGranularity: NSCalendarUnit.Month) != .OrderedDescending)
        }
        return true
    }
    
    private func isBeforeMaxDate(date: NSDate) -> Bool {
        if let maxDate = configuration.logicConfiguration?.maxDate {
            return (NSCalendar.currentCalendar().compareDate(date, toDate: maxDate, toUnitGranularity: NSCalendarUnit.Month) != .OrderedDescending)
        }
        return true
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
        if (scrollView.contentOffset.x != self.view.frame.width * CGFloat(currentMonthPosition)) {
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
            
            // fix the calendar height
            updateCalendarHeight()
            
            // notify the delegate that we changed months
            delegate?.calendar(self, didScrollToDate: currentMonth.date, withNumberOfWeeks: currentMonth.weeksInMonth())

            // rebuild the months so that the new month is in the middle
            rebuildMonths()
            
            // reload data and move to the center of the scroll view
            calendarCollectionView.reloadData()
            calendarCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: currentMonthPosition), atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
        } else {
            // If we are still in the center of the scroll view then we didn't change months
            if (currentMonth != monthsShowing[currentMonthPosition]) {
                currentMonth = monthsShowing[currentMonthPosition]
            }
        }
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
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
            month.backgroundColor = configuration.backgroundColor
        }
     
        return cell
    }
}
