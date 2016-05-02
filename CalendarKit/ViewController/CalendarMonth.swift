//
//  CalendarMonth.swift
//  CalendarKit
//
//  Created by Steven Beyers on 4/29/16.
//  Copyright © 2016 Beyers Apps, LLC. All rights reserved.
//

import UIKit

class CalendarMonth: UICollectionViewCell {
    // static heights for full view
    private let kMonthHeaderHeight = CGFloat(50.0)
    private let kWeekdayHeaderHeight = CGFloat(30.0)
    // static heights for input view
    private let kMonthHeaderHeightAsInput = CGFloat(25.0)
    private let kWeekdayHeaderHeightAsInput = CGFloat(15.0)
    
    // static cell identifiers
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
    // Keep track of the cell that was selected so that we can easily deselect it if another cell is selected
    var selectedCell: UICollectionViewCell?
    
    /// The calendar that is displaying this month - This must be set in order for CalendarKit to work properly
    var containingCalendar: Calendar?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // set the background color
        monthCollectionView.backgroundColor = CalendarDesignKit.calendarBackgroundColor
        
        // register all cells that are needed
        let bundle = NSBundle(identifier: "com.beyersapps.CalendarKit")
        monthCollectionView.registerNib(UINib(nibName: "BasicDateCollectionViewCell", bundle: bundle), forCellWithReuseIdentifier: kBasicCellIdentifier)
        monthCollectionView.registerNib(UINib(nibName: "MonthHeaderCollectionViewCell", bundle: bundle), forCellWithReuseIdentifier: kMonthHeaderIdentifier)
        monthCollectionView.registerNib(UINib(nibName: "WeekdayHeaderCollectionViewCell", bundle: bundle), forCellWithReuseIdentifier: kWeekdayHeaderIdentifier)
        monthCollectionView.registerNib(UINib(nibName: "SpacerCollectionViewCell", bundle: bundle), forCellWithReuseIdentifier: kSpacerIdentifier)
    }
    
    /**
     Gets the height for the month header.
     
     @return CGFloat
    */
    private func monthHeaderHeight() -> CGFloat {
        if let config = containingCalendar?.configuration {
            // If a configuration exists, we should base the height off of the style in the configuration
            switch config.displayStyle {
            case .FullScreen:
                return kMonthHeaderHeight
            case .Custom:
                return kMonthHeaderHeight
            case .InputView:
                return kMonthHeaderHeightAsInput
            }
        } else {
            // use a default height in case the configuration doesn't exist for some reason
            return kMonthHeaderHeight
        }
    }
    
    /**
     Gets the height of the weekday header.
     
     @return The height for the weekday header.
    */
    private func weekdayHeaderHeight() -> CGFloat {
        if let config = containingCalendar?.configuration {
            // If a configuration exists we should base the height off of the style in the configuration
            switch config.displayStyle {
            case .FullScreen:
                return kWeekdayHeaderHeight
            case .Custom:
                return kWeekdayHeaderHeight
            case .InputView:
                return kWeekdayHeaderHeightAsInput
            }
        } else {
            // Use a default height in case the configuration doesn't exist
            return kWeekdayHeaderHeight
        }
    }

}

extension CalendarMonth: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        switch (indexPath.section) {
        case 0:
            // The first item is the month header
            if (indexPath.item == 0) {
                return CGSizeMake(collectionView.frame.width, monthHeaderHeight())
            } else {
                // The second item is a divider that can be 1px tall
                return CGSizeMake(collectionView.frame.width, 1)
            }
        case 1:
            // The second section is the weekday header so calculate the height and width
            let width = (monthCollectionView.frame.size.width-12) / 7
            let size = CGSizeMake(width, weekdayHeaderHeight())
            return size
        default:
            // The third section is the actual calendar - figure out the size for each cell
            let rowsNeeded = monthToDisplay.weeksInMonth()
            let dividerHeight = CGFloat((rowsNeeded - 1) * 2)
            let width = (monthCollectionView.frame.size.width-12) / 7
            let size = CGSizeMake(width, (monthCollectionView.frame.size.height - dividerHeight - monthHeaderHeight() - weekdayHeaderHeight()) / CGFloat(rowsNeeded))
            return size
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        switch (section) {
        case 0:
            return 0
        default:
            // Put 2 px between each cell
            return 2.0
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        switch (section) {
        case 0:
            return 0
        default:
            // Put 2 px between each cell
            return 2.0
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        // We don't need any insets
        return UIEdgeInsets(top: 0 , left: 0, bottom: 0, right: 0)
    }
    
}

extension CalendarMonth: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // always 3 sections
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch (section) {
        case 0:
            // always 2 cells in the first section
            return 2
        case 1:
            // always 7 cells in the second section
            return 7
        default:
            // calculate the number of cells for the calendar
            return monthToDisplay.weeksInMonth() * 7
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        switch (indexPath.section) {
        case 0:
            if (indexPath.item == 0) {
                // build the month header cell
                return monthHeaderCell(forCollectionView: collectionView, indexPath: indexPath)
            } else {
                // get the spacer cell
                let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kSpacerIdentifier, forIndexPath: indexPath)
                cell.backgroundColor = CalendarDesignKit.calendarBackgroundColor
                return cell
            }
        case 1:
            // build the weekeday header cell
            return weekdayHeaderCell(forCollectionView: collectionView, indexPath: indexPath)
        default:
            // build the calendar date cell
            return dateCell(forCollectionView: collectionView, indexPath: indexPath)
        }
    }
    
    /**
     Builds the cell to display the current month.
     
     @param forCollectionView The collection view displaying the cell.
     @param indexPath The index path where the cell will be placed.
    */
    private func monthHeaderCell(forCollectionView collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        let monthHeader = collectionView.dequeueReusableCellWithReuseIdentifier(kMonthHeaderIdentifier, forIndexPath: indexPath)
        
        if let monthHeader = monthHeader as? MonthHeaderCollectionViewCell {
            monthHeader.backgroundColor = CalendarDesignKit.calendarDateColor
            monthHeader.monthName.text = monthToDisplay.monthName()
            
            if let calendar = containingCalendar {
                monthHeader.styleCell(displayStyle: calendar.configuration.displayStyle)
            }
        }
        
        return monthHeader
    }
    
    /**
     Builds the cells to compose the weekday header.
     
     @param forCollectionView The collection view displaying the cell.
     @param indexPath The index path where the cell will be placed.
    */
    private func weekdayHeaderCell(forCollectionView collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        let weekdayHeader = collectionView.dequeueReusableCellWithReuseIdentifier(kWeekdayHeaderIdentifier, forIndexPath: indexPath)
        
        // make sure the correct cell was created
        if let weekdayHeader = weekdayHeader as? WeekdayHeaderCollectionViewCell {
            // TODO: move this to somewhere that it can be run once instead of every time
            // map an index to a day
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
            // set the day text based on the mapped values
            weekdayHeader.dayNameLabel.text = map[indexPath.row]
            
            if let calendar = containingCalendar {
                // style the cell based on the configuration settings
                weekdayHeader.styleCell(displayStyle: calendar.configuration.displayStyle)
            }
        }
        
        return weekdayHeader
    }
    
    /**
     Builds the cells to compose the calendar.
     
     @param forCollectionView The collection view displaying the cell.
     @param indexPath The index path where the cell will be placed.
     */
    private func dateCell(forCollectionView collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kBasicCellIdentifier, forIndexPath: indexPath)
        
        // make sure the correct cell type was made
        if let dateCell = cell as? BasicDateCollectionViewCell {
            // style the cell
            setupStyle(dateCell: dateCell, indexPath: indexPath)
        }
        
        return cell
    }
    
    /**
     Styles the date cell.
     
     @param dateCell The date cell to style.
     @param indexPath The index path where the date cell will be placed.
    */
    private func setupStyle(dateCell dateCell: BasicDateCollectionViewCell, indexPath: NSIndexPath) {
        // Get the date for today
        let date = monthToDisplay.getDateForCell(indexPath: indexPath)
        let outsideOfMonth = monthToDisplay.isDateInMonth(date)
        
        // Figure out the current day of the month
        let day = NSCalendar.currentCalendar().components(.Day, fromDate: date).day
        dateCell.dateLabel.text = "\(day)"
        
        // figure out thecell style and display style from the configuration settings
        let cellStyle: DateCellStyle
        let displayStyle: DisplayStyle
        if let calendar = containingCalendar {
            cellStyle = calendar.configuration.dateTextStyle
            displayStyle = calendar.configuration.displayStyle
        } else {
            displayStyle = .FullScreen
            cellStyle = .TopCenter(verticalOffset: 17)
        }
        
        // give the date cell the info it needs for styling properly
        if (dateIsSelected(date)) {
            dateCell.style(dateIsSelected: true, dateIsOutsideOfMonth: outsideOfMonth, textPlacement: cellStyle, displayStyle: displayStyle)
        } else if (dateIsToday(date)) {
            dateCell.style(dateIsToday: true, dateIsOutsideOfMonth: outsideOfMonth, textPlacement: cellStyle, displayStyle: displayStyle)
        } else {
            dateCell.style(dateIsOutsideOfMonth: outsideOfMonth, textPlacement: cellStyle, displayStyle: displayStyle)
        }
    }
    
}

extension CalendarMonth: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        
        if (indexPath.section == 2) {
            // Get the cell style and display style from configuration settings
            let cellStyle: DateCellStyle
            let displayStyle: DisplayStyle
            if let calendar = containingCalendar {
                cellStyle = calendar.configuration.dateTextStyle
                displayStyle = calendar.configuration.displayStyle
            } else {
                displayStyle = .FullScreen
                cellStyle = .TopCenter(verticalOffset: 17)
            }
            
            // remember which date was selected
            containingCalendar?.selectedDate = monthToDisplay.getDateForCell(indexPath: indexPath)
            if let previousSelected = selectedCell as? BasicDateCollectionViewCell {
                // update the style of the previously selected cell
                if let previousPath = collectionView.indexPathForCell(previousSelected) {
                    setupStyle(dateCell: previousSelected, indexPath: previousPath)
                } else {
                    previousSelected.style(textPlacement: cellStyle, displayStyle: displayStyle)
                }
            }
            
            if let dateCell = collectionView.cellForItemAtIndexPath(indexPath) as? BasicDateCollectionViewCell {
                // update the style of the newly selected cell
                dateCell.style(dateIsSelected: true, textPlacement: cellStyle, displayStyle: displayStyle)
                // remember that this cell is now selected
                selectedCell = dateCell
            }
            
            // notify the delegate that a new date was selected
            if let calendar = containingCalendar, date = calendar.selectedDate {
                calendar.delegate?.calendar?(calendar, didSelectDate: date)
            }
        }
    }
    
}

/**
 Helper mothods for handling NSDate
 */
extension CalendarMonth {
    
    /**
     Determine if two dates are equal. This will ignore time and therefore return true if the day, month and year are equal. Otherwise, return false.
     
     @param firstDate The first date to evaluate
     @param secondDate The second date to evaluate
     @return A Bool value indicating if the dates are equal (true) or not (false).
    */
    private func datesAreEqual(firstDate dateOne: NSDate, secondDate dateTwo: NSDate) -> Bool {
        // Get the calendar
        let calendar = NSCalendar.currentCalendar()
        // Set the componenets for each date
        let firstComponents = calendar.components([.Day, .Month, .Year], fromDate: dateOne)
        let secondComponents = calendar.components([.Day, .Month, .Year], fromDate: dateTwo)
        
        // compare the day, month and year between the two date componenets
        if (firstComponents.day == secondComponents.day && firstComponents.month == secondComponents.month && firstComponents.year == secondComponents.year) {
            return true
        }
        
        return false
    }
    
    /**
     Determine if the given date is equal to the previously selected date. If no date has been selected yet then we will always return fasle
     
     @param date The date that we want to check against the selected date.
    */
    func dateIsSelected(date: NSDate) -> Bool {
        // Check to see if there is a previously selected date
        if let selected = containingCalendar?.selectedDate {
            // compare the selected date with the given date
            return datesAreEqual(firstDate: date, secondDate: selected)
        }
        
        // If no date was selected then this will needs to return false
        return false
    }
    
    /**
     Checks to see if the given date is the current date.
     
     @param date The date that we want to check against the current date.
    */
    func dateIsToday(date: NSDate) -> Bool {
        // compare current date against the given date
        return datesAreEqual(firstDate: date, secondDate: NSDate())
    }
    
}
