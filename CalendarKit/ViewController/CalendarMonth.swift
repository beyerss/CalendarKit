//
//  CalendarMonth.swift
//  CalendarKit
//
//  Created by Steven Beyers on 4/29/16.
//  Copyright © 2016 Beyers Apps, LLC. All rights reserved.
//

import UIKit

class CalendarMonth: UICollectionViewCell {
    
    private let kMonthHeaderHeight = CGFloat(50.0)
    private let kWeekdayHeaderHeight = CGFloat(30.0)
    private let kBasicCellIdentifier = "BasicDateCell"
    private let kMonthHeaderIdentifier = "MonthHeaderCell"
    private let kWeekdayHeaderIdentifier = "WeekdayHeaderCell"
    private let kSpacerIdentifier = "SpacerCell"

    @IBOutlet weak var monthCollectionView: UICollectionView!
    var monthToDisplay = Month(monthDate: NSDate()) {
        didSet {
            // we need to update the month header and the dates
            self.monthCollectionView.reloadData()
        }
    }
    var selectedCell: UICollectionViewCell?
    
    /// The calendar that is displaying this month - This must be set in order for CalendarKit to work properly
    var containingCalendar: Calendar?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        monthCollectionView.backgroundColor = CalendarDesignKit.calendarBackgroundColor
        
        // register all cells that are needed
        let bundle = NSBundle(identifier: "com.beyersapps.CalendarKit")
        monthCollectionView.registerNib(UINib(nibName: "BasicDateCollectionViewCell", bundle: bundle), forCellWithReuseIdentifier: kBasicCellIdentifier)
        monthCollectionView.registerNib(UINib(nibName: "MonthHeaderCollectionViewCell", bundle: bundle), forCellWithReuseIdentifier: kMonthHeaderIdentifier)
        monthCollectionView.registerNib(UINib(nibName: "WeekdayHeaderCollectionViewCell", bundle: bundle), forCellWithReuseIdentifier: kWeekdayHeaderIdentifier)
        monthCollectionView.registerNib(UINib(nibName: "SpacerCollectionViewCell", bundle: bundle), forCellWithReuseIdentifier: kSpacerIdentifier)
    }

}

extension CalendarMonth: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        switch (indexPath.section) {
        case 0:
            if (indexPath.item == 0) {
                return CGSizeMake(collectionView.frame.width, kMonthHeaderHeight)
            } else {
                return CGSizeMake(collectionView.frame.width, 1)
            }
        case 1:
            let width = (monthCollectionView.frame.size.width-12) / 7
            let size = CGSizeMake(width, kWeekdayHeaderHeight)
            return size
        default:
            let rowsNeeded = monthToDisplay.weeksInMonth()
            let dividerHeight = CGFloat((rowsNeeded - 1) * 2)
            let width = (monthCollectionView.frame.size.width-12) / 7
            let size = CGSizeMake(width, (monthCollectionView.frame.size.height - dividerHeight - kMonthHeaderHeight - kWeekdayHeaderHeight) / CGFloat(rowsNeeded))
            return size
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        switch (section) {
        case 0:
            return 0
        default:
            return 2.0
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        switch (section) {
        case 0:
            return 0
        default:
            return 2.0
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0 , left: 0, bottom: 0, right: 0)
    }
    
}

extension CalendarMonth: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch (section) {
        case 0:
            return 2
        case 1:
            return 7
        default:
            return monthToDisplay.weeksInMonth() * 7
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        switch (indexPath.section) {
        case 0:
            if (indexPath.item == 0) {
                return monthHeaderCell(forCollectionView: collectionView, indexPath: indexPath)
            } else {
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kSpacerIdentifier, forIndexPath: indexPath)
                cell.backgroundColor = CalendarDesignKit.calendarBackgroundColor
                return cell
            }
        case 1:
            return weekdayHeaderCell(forCollectionView: collectionView, indexPath: indexPath)
        default:
            return dateCell(forCollectionView: collectionView, indexPath: indexPath)
        }
    }
    
    private func monthHeaderCell(forCollectionView collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        let monthHeader = collectionView.dequeueReusableCellWithReuseIdentifier(kMonthHeaderIdentifier, forIndexPath: indexPath)
        
        if let monthHeader = monthHeader as? MonthHeaderCollectionViewCell {
            monthHeader.backgroundColor = CalendarDesignKit.calendarDateColor
            monthHeader.monthName.text = monthToDisplay.monthName()
        }
        
        return monthHeader
    }
    
    private func weekdayHeaderCell(forCollectionView collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        let weekdayHeader = collectionView.dequeueReusableCellWithReuseIdentifier(kWeekdayHeaderIdentifier, forIndexPath: indexPath)
        
        if let weekdayHeader = weekdayHeader as? WeekdayHeaderCollectionViewCell {
            let possibleRows = [0, 1, 2, 3, 4, 5, 6]
            let map: [String] = possibleRows.map({ (input: Int) -> String in
                switch (input) {
                case 0:
                    return "Sun"
                case 1:
                    return "Mon"
                case 2:
                    return "Tues"
                case 3:
                    return "Wed"
                case 4:
                    return "Thurs"
                case 5:
                    return "Fri"
                default:
                    return "Sat"
                }
            })
            weekdayHeader.dayNameLabel.text = map[indexPath.row]
        }
        
        return weekdayHeader
    }
    
    private func dateCell(forCollectionView collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kBasicCellIdentifier, forIndexPath: indexPath)
        
        if let dateCell = cell as? BasicDateCollectionViewCell {
            setupStyle(dateCell: dateCell, indexPath: indexPath)
        }
        
        return cell
    }
    
    private func setupStyle(dateCell dateCell: BasicDateCollectionViewCell, indexPath: NSIndexPath) {
        // Get the date for today
        let date = monthToDisplay.getDateForCell(indexPath: indexPath)
        let outsideOfMonth = monthToDisplay.isDateInMonth(date)
        
        let day = NSCalendar.currentCalendar().components(.Day, fromDate: date).day
        dateCell.dateLabel.text = "\(day)"
        
        if (dateIsSelected(date)) {
            dateCell.style(dateIsSelected: true, dateIsOutsideOfMonth: outsideOfMonth)
        } else if (dateIsToday(date)) {
            dateCell.style(dateIsToday: true, dateIsOutsideOfMonth: outsideOfMonth)
        } else {
            dateCell.style(dateIsOutsideOfMonth: outsideOfMonth)
        }
    }
    
}

extension CalendarMonth: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        
        // remember which date was selected
        containingCalendar?.selectedDate = monthToDisplay.getDateForCell(indexPath: indexPath)
        if let previousSelected = selectedCell as? BasicDateCollectionViewCell {
            if let previousPath = collectionView.indexPathForCell(previousSelected) {
                setupStyle(dateCell: previousSelected, indexPath: previousPath)
            } else {
                previousSelected.style()
            }
        }
        
        if let dateCell = collectionView.cellForItemAtIndexPath(indexPath) as? BasicDateCollectionViewCell {
            dateCell.style(dateIsSelected: true)
            selectedCell = dateCell
        }
        
        if let calendar = containingCalendar, date = calendar.selectedDate {
            calendar.delegate?.calendar?(calendar, didSelectDate: date)
        }
    }
    
}

internal extension CalendarMonth {
    
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
        if let selected = containingCalendar?.selectedDate {
            return datesAreEqual(firstDate: date, secondDate: selected)
        }
        
        return false
    }
    
    func dateIsToday(date: NSDate) -> Bool {
        return datesAreEqual(firstDate: date, secondDate: NSDate())
    }
    
}
