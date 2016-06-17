//
//  CalendarMonth.swift
//  CalendarKit
//
//  Created by Steven Beyers on 4/29/16.
//  Copyright © 2016 Beyers Apps, LLC. All rights reserved.
//

import UIKit

class CalendarMonth: UICollectionViewCell {
    // static cell identifiers
    private let kBasicCellIdentifier = "BasicDateCell"
    private let kMonthHeaderIdentifier = "MonthHeaderCell"
    private let kWeekdayHeaderIdentifier = "WeekdayHeaderCell"
    private let kSpacerIdentifier = "SpacerCell"

    @IBOutlet weak var monthCollectionView: UICollectionView!
    var monthToDisplay = Month(monthDate: Date()) {
        didSet {
            // we need to update the month header and the dates
            self.monthCollectionView.reloadData()
        }
    }
    // Keep track of the cell that was selected so that we can easily deselect it if another cell is selected
    var selectedCell: UICollectionViewCell?
    
    /// The calendar that is displaying this month - This must be set in order for CalendarKit to work properly
    var containingCalendar: Calendar?
    
    override var backgroundColor: UIColor? {
        didSet {
            monthCollectionView?.backgroundColor = backgroundColor
        }
    }
    
    var cellSpacing: CGFloat {
        get {
            if let config = containingCalendar?.configuration {
                return config.spaceBetweenDates
            }
            // Put 2 px between each cell
            return 2.0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // register all cells that are needed
        let bundle = Bundle(identifier: "com.beyersapps.CalendarKit")
        monthCollectionView.register(UINib(nibName: "BasicDateCollectionViewCell", bundle: bundle), forCellWithReuseIdentifier: kBasicCellIdentifier)
        monthCollectionView.register(UINib(nibName: "MonthHeaderCollectionViewCell", bundle: bundle), forCellWithReuseIdentifier: kMonthHeaderIdentifier)
        monthCollectionView.register(UINib(nibName: "WeekdayHeaderCollectionViewCell", bundle: bundle), forCellWithReuseIdentifier: kWeekdayHeaderIdentifier)
        monthCollectionView.register(UINib(nibName: "SpacerCollectionViewCell", bundle: bundle), forCellWithReuseIdentifier: kSpacerIdentifier)
    }

}

extension CalendarMonth: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var monthHeight: CGFloat = 50
        var weekHeight: CGFloat = 30
        var rowHeight: CGFloat?
        
        if let config = containingCalendar?.configuration {
            monthHeight = config.monthHeaderConfiguration.height
            weekHeight = config.weekdayHeaderConfiguration.height
            
            if (config.dynamicHeight) {
                rowHeight = config.dateCellConfiguration.heightForDynamicHeightRows
            }
        }
        
        switch ((indexPath as NSIndexPath).section) {
        case 0:
            // The first item is the month header
            if ((indexPath as NSIndexPath).item == 0) {
                return CGSize(width: collectionView.frame.width, height: monthHeight)
            } else {
                // The second item is a divider that can be 1px tall
                return CGSize(width: collectionView.frame.width, height: 1)
            }
        case 1:
            // The second section is the weekday header so calculate the height and width
            let width = (monthCollectionView.frame.size.width-(6 * cellSpacing)) / 7
            let size = CGSize(width: width, height: weekHeight)
            return size
        default:
            // The third section is the actual calendar - figure out the size for each cell
            let rowsNeeded = monthToDisplay.weeksInMonth()
            let dividerHeight = CGFloat((rowsNeeded - 1)) * cellSpacing
            let width = (monthCollectionView.frame.size.width-(6 * cellSpacing)) / 7
            let size: CGSize
            if let rowHeight = rowHeight {
                size = CGSize(width: width, height: rowHeight)
            } else {
                size = CGSize(width: width, height: (monthCollectionView.frame.size.height - dividerHeight - monthHeight - weekHeight) / CGFloat(rowsNeeded))
            }
            return size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        switch (section) {
        case 0:
            return 0
        default:
            return cellSpacing
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        switch (section) {
        case 0:
            return 0
        default:
            return cellSpacing
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // We don't need any insets
        return UIEdgeInsets(top: 0 , left: 0, bottom: 0, right: 0)
    }
    
}

extension CalendarMonth: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // always 3 sections
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch ((indexPath as NSIndexPath).section) {
        case 0:
            if ((indexPath as NSIndexPath).item == 0) {
                // build the month header cell
                return monthHeaderCell(forCollectionView: collectionView, indexPath: indexPath)
            } else {
                // get the spacer cell
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kSpacerIdentifier, for: indexPath)
                cell.backgroundColor = self.backgroundColor
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
    private func monthHeaderCell(forCollectionView collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let monthHeader = collectionView.dequeueReusableCell(withReuseIdentifier: kMonthHeaderIdentifier, for: indexPath)
        
        if let monthHeader = monthHeader as? MonthHeaderCollectionViewCell {
            monthHeader.monthName.text = monthToDisplay.monthName()
            
            if let calendar = containingCalendar {
                monthHeader.monthName.textColor = calendar.configuration.monthHeaderConfiguration.textColor
                monthHeader.monthName.font = calendar.configuration.monthHeaderConfiguration.font
                monthHeader.backgroundColor = calendar.configuration.monthHeaderConfiguration.backgroundColor
            }
        }
        
        return monthHeader
    }
    
    /**
     Builds the cells to compose the weekday header.
     
     @param forCollectionView The collection view displaying the cell.
     @param indexPath The index path where the cell will be placed.
    */
    private func weekdayHeaderCell(forCollectionView collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let weekdayHeader = collectionView.dequeueReusableCell(withReuseIdentifier: kWeekdayHeaderIdentifier, for: indexPath)
        
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
            weekdayHeader.dayNameLabel.text = map[(indexPath as NSIndexPath).row]
            
            if let calendar = containingCalendar {
                // style the cell based on the configuration settings
                weekdayHeader.dayNameLabel.font = calendar.configuration.weekdayHeaderConfiguration.font
                weekdayHeader.dayNameLabel.textColor = calendar.configuration.weekdayHeaderConfiguration.textColor
                weekdayHeader.contentView.backgroundColor = calendar.configuration.weekdayHeaderConfiguration.backgroundColor
            }
        }
        
        return weekdayHeader
    }
    
    /**
     Builds the cells to compose the calendar.
     
     @param forCollectionView The collection view displaying the cell.
     @param indexPath The index path where the cell will be placed.
     */
    private func dateCell(forCollectionView collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kBasicCellIdentifier, for: indexPath)
        
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
    private func setupStyle(dateCell: BasicDateCollectionViewCell, indexPath: IndexPath) {
        // I need to have a containing calendar or else I don't know how to set anything up
        guard let containingCalendar = containingCalendar else { return }
        
        // Get the date for today
        let date = monthToDisplay.getDateForCell(indexPath: indexPath)
        let disabled = !shouldEnable(date: date as Date)
        
        // Figure out the current day of the month
        if let day = Foundation.Calendar.current().components(.day, from: date as Date).day {
            dateCell.dateLabel.text = "\(day)"
        } else {
            dateCell.dateLabel.text = ""
        }
        
        // figure out thecell style and display style from the configuration settings
        let calendarConfiguration = containingCalendar.configuration
        let cellStyle: ViewPlacement
        var circleSizeOffset: CGFloat?
        let font: UIFont
        
        cellStyle = calendarConfiguration.dateCellConfiguration.textStyle
        circleSizeOffset = calendarConfiguration.dateCellConfiguration.circleSizeOffset
        font = calendarConfiguration.dateCellConfiguration.font
        
        dateCell.circleColor = calendarConfiguration.dateCellConfiguration.highlightColor
        // set up font styles
        dateCell.enabledTextColor = calendarConfiguration.dateCellConfiguration.textEnabledColor
        dateCell.disabledTextColor = calendarConfiguration.dateCellConfiguration.textDisabledColor
        dateCell.highlightedTextColor = calendarConfiguration.dateCellConfiguration.textHighlightedColor
        dateCell.selectedTextColor = calendarConfiguration.dateCellConfiguration.textSelectedColor
        
        let accessory = containingCalendar.delegate?.acessory(forDate: date, onCalendar: containingCalendar)
        
        // give the date cell the info it needs for styling properly
        if (dateIsSelected(date as Date)) {
            dateCell.style(dateIsSelected: true, disabled: disabled, textPlacement: cellStyle, font: font, circleSizeOffset: circleSizeOffset, calendarConfiguration: calendarConfiguration, accessory: accessory)
        } else if (dateIsToday(date as Date)) {
            dateCell.style(dateIsToday: true, disabled: disabled, textPlacement: cellStyle, font: font, circleSizeOffset: circleSizeOffset, calendarConfiguration: calendarConfiguration, accessory: accessory)
        } else {
            dateCell.style(disabled: disabled, textPlacement: cellStyle, font: font, circleSizeOffset: circleSizeOffset, calendarConfiguration: calendarConfiguration, accessory: accessory)
        }
    }
    
}

extension CalendarMonth: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        
        if ((indexPath as NSIndexPath).section == 2) {
            // determine if the date is in the current month
            let date = monthToDisplay.getDateForCell(indexPath: indexPath)
            if (!shouldEnable(date: date as Date)) {
                // The date is outside of the current month so we will not select it
                return
            }
            
            // Get the cell style and display style from configuration settings
            let configuration = containingCalendar?.configuration
            let cellStyle: ViewPlacement
            var circleOffset: CGFloat?
            let font: UIFont
            
            if let configuration = configuration {
                cellStyle = configuration.dateCellConfiguration.textStyle
                circleOffset = configuration.dateCellConfiguration.circleSizeOffset
                font = configuration.dateCellConfiguration.font
            } else {
                cellStyle = .topCenter(verticalOffset: 17)
                font = UIFont.preferredDateFont()
            }
            
            // remember which date was selected
            containingCalendar?.selectedDate = monthToDisplay.getDateForCell(indexPath: indexPath)
            if let previousSelected = selectedCell as? BasicDateCollectionViewCell {
                
                // update the style of the previously selected cell
                if let previousPath = collectionView.indexPath(for: previousSelected) {
                    setupStyle(dateCell: previousSelected, indexPath: previousPath)
                } else {
                    previousSelected.style(textPlacement: cellStyle, font: font, circleSizeOffset: circleOffset, calendarConfiguration: configuration, accessory: previousSelected.accessory)
                }
            }
            
            if let dateCell = collectionView.cellForItem(at: indexPath) as? BasicDateCollectionViewCell {
                // update the style of the newly selected cell
                dateCell.style(dateIsSelected: true, textPlacement: cellStyle, font: font, circleSizeOffset: circleOffset, calendarConfiguration: configuration, accessory: dateCell.accessory)
                // remember that this cell is now selected
                selectedCell = dateCell
            }
            
            // notify the delegate that a new date was selected
            if let calendar = containingCalendar, date = calendar.selectedDate {
                calendar.delegate?.calendar(calendar, didSelectDate: date)
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
    private func datesAreEqual(firstDate dateOne: Date, secondDate dateTwo: Date) -> Bool {
        // Get the calendar
        let calendar = Foundation.Calendar.current()
        // Set the componenets for each date
        let firstComponents = calendar.components([.day, .month, .year], from: dateOne)
        let secondComponents = calendar.components([.day, .month, .year], from: dateTwo)
        
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
    func dateIsSelected(_ date: Date) -> Bool {
        // Check to see if there is a previously selected date
        if let selected = containingCalendar?.selectedDate {
            // compare the selected date with the given date
            return datesAreEqual(firstDate: date, secondDate: selected as Date)
        }
        
        // If no date was selected then this will needs to return false
        return false
    }
    
    /**
     Checks to see if the given date is the current date.
     
     @param date The date that we want to check against the current date.
    */
    func dateIsToday(_ date: Date) -> Bool {
        // compare current date against the given date
        return datesAreEqual(firstDate: date, secondDate: Date())
    }
    
    /**
     Checks to see if a date should be enabled.
    */
    func shouldEnable(date: Date) -> Bool {
        // disable date if we are outside of the current month
        if (monthToDisplay.isDateOutOfMonth(date)) {
            // The date is outside of the current month so it should be disabled
            return false
        }
        
        // check to see if we have a minimum date
        if let minDate = containingCalendar?.configuration.logicConfiguration?.minDate {
            // disabeld if the date is before the min date
            if (Foundation.Calendar.current().compare(minDate as Date, to: date, toUnitGranularity: Foundation.Calendar.Unit.day) == .orderedDescending) {
                return false
            }
        }
        
        // check to see if we have a max date
        if let maxDate = containingCalendar?.configuration.logicConfiguration?.maxDate {
            // disabled if the date is after the max date
            if (Foundation.Calendar.current().compare(maxDate as Date, to: date, toUnitGranularity: .day) == .orderedAscending) {
                return false
            }
        }
        
        // check to see if weekends should be disabled
        if let shouldDisableWeekends = containingCalendar?.configuration.logicConfiguration?.shouldDisableWeekends where shouldDisableWeekends == true {
            // Determine if the date is a weekend
            if (isWeekend(date: date)) {
                return false
            }
        }
        
        // check to see if this date is in the list of disabled dates
        if let disabledDates = containingCalendar?.configuration.logicConfiguration?.disabledDates {
            let relevantDisabledDates = disabledDates.filter({ return (Foundation.Calendar.current().compare($0 as Date, to: date, toUnitGranularity: .day) == .orderedSame) })
            
            if let _ = relevantDisabledDates.first {
                // This date is a weekend
                return false
            }
        }
        
        return true
    }
    
    /**
     Checks to see if a date is a weekend
    */
    private func isWeekend(date: Date) -> Bool {
        let calendar = Foundation.Calendar.current()
        let weekdayRange = calendar.maximumRange(of: .weekday)
        let components = calendar.components(.weekday, from: date)
        let weekdayOfDate = components.weekday
        
        if (weekdayOfDate == weekdayRange.location || weekdayOfDate == weekdayRange.length) {
            return true
        }
        
        return false
    }
    
}
