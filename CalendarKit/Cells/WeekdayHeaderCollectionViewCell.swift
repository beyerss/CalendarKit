//
//  WeekdayHeaderCollectionViewCell.swift
//  CalendarKit
//
//  Created by Steven Beyers on 4/29/16.
//  Copyright © 2016 Beyers Apps, LLC. All rights reserved.
//

import UIKit

class WeekdayHeaderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dayNameLabel.font = UIFont.preferredWeekdayHeaderFont()
    }
    /**
     Updates the font based on the style.
     
     @param displayStyle The style for the calendar
     */
    func styleCell(displayStyle style: DisplayStyle) {
        // update font based on given style
        switch style {
        case .InputView:
            dayNameLabel.font = UIFont.preferredInputViewWeekdayHeaderFont()
        default:
            dayNameLabel.font = UIFont.preferredWeekdayHeaderFont()
        }
    }

}
