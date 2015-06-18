//
//  Calendar.swift
//  CalendarKit
//
//  Created by Steven Beyers on 5/23/15.
//  Copyright (c) 2015 Beyers Apps, LLC. All rights reserved.
//

import UIKit

public class Calendar: UIViewController {

    @IBOutlet private weak var monthLabel: UILabel!
    @IBOutlet private weak var calendarCollectionView: UICollectionView!
    
    private var monthsShowing = Array<Month>()
    private var monthFormatter: NSDateFormatter!
    private var currentMonth = Month(monthDate: NSDate()) {
        didSet {
            monthLabel.text = currentMonth.monthName(monthFormatter)
        }
    }
    
    var selectedDate: NSDate?
    private var selectedCell: UICollectionViewCell?
    
    internal init() {
        super.init(nibName: "Calendar", bundle: NSBundle(identifier: "com.beyersapps.CalendarKit"))
    }

    public required init(coder aDecoder: NSCoder) {
        super.init(nibName: "Calendar", bundle: NSBundle(identifier: "com.beyersapps.CalendarKit"))
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = CalendarDesignKit.calendarBackgroundColor
        
        // create the date formatter used for displaying the month
        monthFormatter = NSDateFormatter()
        monthFormatter.dateFormat = "MMMM"
        
        // register cell
        let bundle = NSBundle(identifier: "com.beyersapps.CalendarKit")
        let xib = UINib(nibName: "BasicDateCollectionViewCell", bundle: bundle)
        calendarCollectionView.registerNib(xib, forCellWithReuseIdentifier: "BasicDateCell")
        
        // Set up data to start at the date 2 months ago
        rebuildMonths()
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // We need to scroll to the second section. That is the center of the data that is showed
        // and helps us give the illusion of infinite scrolling
        self.view.layoutIfNeeded()
        calendarCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 2), atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
    }
    
    private func rebuildMonths() {
        monthsShowing = Array<Month>()
        monthsShowing.append(Month(otherMonth: currentMonth, offsetMonths: -2))
        monthsShowing.append(Month(otherMonth: currentMonth, offsetMonths: -1))
        monthsShowing.append(currentMonth)
        monthsShowing.append(Month(otherMonth: currentMonth, offsetMonths: 1))
        monthsShowing.append(Month(otherMonth: currentMonth, offsetMonths: 2))
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
        
        let month = monthsShowing[indexPath.section]
        
        let rowsNeeded = month.weeksInMonth()
        let dividerHeight = CGFloat((rowsNeeded - 1) * 2)
        return CGSizeMake((calendarCollectionView.frame.size.width-12) / 7, (calendarCollectionView.frame.size.height - dividerHeight) / CGFloat(rowsNeeded))
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
        selectedDate = monthsShowing[indexPath.section].getDateForCell(indexPath: indexPath)
        if let previousSelected = selectedCell as? BasicDateCollectionViewCell {
            if let previousPath = collectionView.indexPathForCell(previousSelected) {
                setupStyle(previousSelected, indexPath: previousPath)
            } else {
                previousSelected.style()
            }
        }
        
        if let dateCell = collectionView.cellForItemAtIndexPath(indexPath) as? BasicDateCollectionViewCell {
            dateCell.style(dateIsSelected: true)
            selectedCell = dateCell
        }
    }
    
}

extension Calendar: UICollectionViewDataSource {
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let month = monthsShowing[section]
        
        let cellCount = month.weeksInMonth() * 7
        return cellCount
    }
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return monthsShowing.count
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // Get the cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BasicDateCell", forIndexPath: indexPath) as UICollectionViewCell
        if let dateCell = cell as? BasicDateCollectionViewCell {
            setupStyle(dateCell, indexPath: indexPath)
        }
        
        return cell
    }
    
    private func setupStyle(dateCell: BasicDateCollectionViewCell, indexPath index: NSIndexPath) {
        let month = monthsShowing[index.section]
        
        // Get the date for today
        let date = month.getDateForCell(indexPath: index)
        
        let day = NSCalendar.currentCalendar().components(.Day, fromDate: date).day
        dateCell.dateLabel.text = "\(day)"
        
        if (dateIsSelected(date)) {
            dateCell.style(dateIsSelected: true)
        } else if (dateIsToday(date)) {
            dateCell.style(dateIsToday: true)
        } else {
            dateCell.style()
        }
    }
}

internal extension Calendar {
    
    private func datesAreEqual(firstDate dateOne: NSDate, secondDate dateTwo: NSDate) -> Bool {
        let calendar = NSCalendar.currentCalendar()
        let firstComponents = calendar.components([.Day, .Month, .Year], fromDate: dateOne)
        let secondComponents = calendar.components([.Day, .Month, .Year], fromDate: dateTwo)
        
        if (firstComponents.day == secondComponents.day && firstComponents.month == secondComponents.month && firstComponents.year == secondComponents.year) {
            return true
        }
        
        return false
    }
    
    func dateIsSelected(date: NSDate) -> Bool {
        if let selected = selectedDate {
            return datesAreEqual(firstDate: date, secondDate: selected)
        }
        
        return false
    }
    
    func dateIsToday(date: NSDate) -> Bool {
        return datesAreEqual(firstDate: date, secondDate: NSDate())
    }
    
}
