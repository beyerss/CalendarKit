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
    
    private var monthsShowing = Array<Month>()
    private var currentMonth = Month(monthDate: NSDate())
    
    public var selectedDate: NSDate?
    
    public var delegate: CalendarDelegate?
    
    public init() {
        super.init(nibName: "Calendar", bundle: NSBundle(identifier: "com.beyersapps.CalendarKit"))
    }

    public required init(coder aDecoder: NSCoder) {
        super.init(nibName: "Calendar", bundle: NSBundle(identifier: "com.beyersapps.CalendarKit"))
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = CalendarDesignKit.calendarBackgroundColor
        
        // register cell
        let bundle = NSBundle(identifier: "com.beyersapps.CalendarKit")
        calendarCollectionView.registerNib(UINib(nibName: "CalendarMonth", bundle: bundle), forCellWithReuseIdentifier: "monthCell")
        
        // Set up data to start at the date 2 months ago
        rebuildMonths(currentMonthOnly: true)
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.calendarCollectionView.reloadData()
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        rebuildMonths()
        calendarCollectionView.reloadData()
        calendarCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 2), atScrollPosition: .Left, animated: false)
    }
    
    private func rebuildMonths(currentMonthOnly currentOnly: Bool = false) {
        monthsShowing = Array<Month>()
        
        if (currentOnly) {
            let tempMonth = currentMonth
            currentMonth = tempMonth
            monthsShowing.append(currentMonth)
        } else {
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
        
        let month = monthsShowing[indexPath.section]
        if (month != currentMonth) {
            currentMonth = month
        }
    }
    
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
            
            delegate?.calendar?(self, didScrollToDate: currentMonth.date, withNumberOfWeeks: currentMonth.weeksInMonth())

            rebuildMonths()
            calendarCollectionView.reloadData()
            calendarCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 2), atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
        } else {
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
        return monthsShowing.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // Get the month cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("monthCell", forIndexPath: indexPath)
        if let month = cell as? CalendarMonth {
            month.containingCalendar = self
            month.monthToDisplay = monthsShowing[indexPath.section]
        }
     
        return cell
    }
}
