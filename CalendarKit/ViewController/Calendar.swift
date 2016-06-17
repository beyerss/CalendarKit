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
    private var currentMonth = Month(monthDate: Date())
    // The position of the current month in the scroll view
    private var currentMonthPosition: Int = 0
    
    // The date that has been selected
    public var selectedDate: Date?
    
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
        super.init(nibName: "Calendar", bundle: Bundle(identifier: "com.beyersapps.CalendarKit"))
        
        // set the configuration to the one specified
        if let config = configuration {
            self.configuration = config
        }
    }

    public required init(coder aDecoder: NSCoder) {
        super.init(nibName: "Calendar", bundle: Bundle(identifier: "com.beyersapps.CalendarKit"))
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // set the month format
        currentMonth.useMonthFormat(configuration.monthFormat)
        
        // set the background color
        view.backgroundColor = configuration.backgroundColor
        calendarCollectionView.backgroundColor = configuration.backgroundColor
        
        // register cell
        let bundle = Bundle(identifier: "com.beyersapps.CalendarKit")
        calendarCollectionView.register(UINib(nibName: "CalendarMonth", bundle: bundle), forCellWithReuseIdentifier: "monthCell")
        
        // Set up data to start at the date 2 months ago
        rebuildMonths(currentMonthOnly: true)
        
        // tell the delegate what month I'm on
        delegate?.calendar(self, didScrollToDate: currentMonth.date, withNumberOfWeeks: currentMonth.weeksInMonth())
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // fix the calendar height
        updateCalendarHeight()
        
        // reload the data whenever the view appears
        self.calendarCollectionView.reloadData()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // rebuild the month array when the view appears
        rebuildMonths()
        
        // reload data and make sure we are at the center month so that we can scroll both ways
        calendarCollectionView.reloadData()
        calendarCollectionView.scrollToItem(at: IndexPath(item: 0, section: currentMonthPosition), at: .left, animated: false)
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        coordinator.animateAlongsideTransition({ (context: UIViewControllerTransitionCoordinatorContext) in
//            // do nothing
//        }) { [weak self](context: UIViewControllerTransitionCoordinatorContext) in
//            self?.calendarCollectionView.collectionViewLayout.invalidateLayout()
//            self?.view.setNeedsDisplay()
//                self?.calendarCollectionView.reloadData()
//        }
        coordinator.animate(alongsideTransition: { [weak self](context) -> Void in
            
            self?.calendarCollectionView.collectionViewLayout.invalidateLayout()
            
            }, completion: { [weak self](context) -> Void in
                guard let weakSelf = self else { return }
                
                weakSelf.calendarCollectionView.reloadData()
                weakSelf.calendarCollectionView.scrollToItem(at: IndexPath(item: 0, section: weakSelf.currentMonthPosition), at: .left, animated: false)
                
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
                UIView.animate(withDuration: 0.5, animations: {[weak self]() in
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
    
    private func getFirstDayOfMonthOffsetFromCurrentMonth(_ offset: Int) -> Date? {
        let calendar = Foundation.Calendar.current()
        let date = calendar.date(byAdding: .month, value: offset, to: currentMonth.date as Date, options: [])!
        
        return date
    }
    
    private func isAfterMinDate(_ date: Date) -> Bool {
        if let minDate = configuration.logicConfiguration?.minDate {
            return (Foundation.Calendar.current().compare(minDate as Date, to: date, toUnitGranularity: Foundation.Calendar.Unit.month) != .orderedDescending)
        }
        return true
    }
    
    private func isBeforeMaxDate(_ date: Date) -> Bool {
        if let maxDate = configuration.logicConfiguration?.maxDate {
            return (Foundation.Calendar.current().compare(date, to: maxDate as Date, toUnitGranularity: Foundation.Calendar.Unit.month) != .orderedDescending)
        }
        return true
    }

}

 extension Calendar: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // Keep track of the month being displayed
        let month = monthsShowing[(indexPath as NSIndexPath).section]
        if (month != currentMonth) {
            currentMonth = month
        }
    }
    
    /**
     Handle scrolling ending
    */
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
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
            calendarCollectionView.scrollToItem(at: IndexPath(item: 0, section: currentMonthPosition), at: UICollectionViewScrollPosition.left, animated: false)
        } else {
            // If we are still in the center of the scroll view then we didn't change months
            if (currentMonth != monthsShowing[currentMonthPosition]) {
                currentMonth = monthsShowing[currentMonthPosition]
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calendarCollectionView.frame.size
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Nothing happens here b/c we can only select individual cells
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
}

extension Calendar: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // We are showing one CalendarMonth cell for each section
        return 1
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Show one section for each month
        return monthsShowing.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get the month cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "monthCell", for: indexPath)
        if let month = cell as? CalendarMonth {
            // let the monthCell know that I own it
            month.containingCalendar = self
            month.monthToDisplay = monthsShowing[(indexPath as NSIndexPath).section]
            month.backgroundColor = configuration.backgroundColor
        }
     
        return cell
    }
}
