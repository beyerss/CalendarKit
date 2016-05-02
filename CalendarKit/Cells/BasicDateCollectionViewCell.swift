//
//  BasicDateCollectionViewCell.swift
//  CalendarKit
//
//  Created by Steven Beyers on 5/23/15.
//  Copyright (c) 2015 Beyers Apps, LLC. All rights reserved.
//

import UIKit

class BasicDateCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    private var dateIsToday: Bool = false
    private var dateIsWeekend: Bool = false
    private var dateIsSelected: Bool = false
    private var dateIsOutsideOfMonth: Bool = false
    private var verticalConstraint: NSLayoutConstraint?
    // We need to store the text placement because it is needed everytime drawRect is called
    private var textPlacement: DateCellStyle = .TopCenter(verticalOffset: 17)
    
    /**
     Updates the dateLabel text so indicate when the cell was selected
    */
    override var highlighted: Bool {
        didSet {
            if (highlighted) {
                dateLabel.alpha = 0.3
            } else {
                dateLabel.alpha = 1.0
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // reset defaults
        dateIsToday = false
        dateIsWeekend = false
        dateIsSelected = false
        
        dateLabel.textColor = UIColor.blackColor()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // set background color
        backgroundColor = CalendarDesignKit.dateBackgroundColor
        // style cell text placement
        setupText(.TopCenter(verticalOffset: 17))
        // set text font
        dateLabel.font = UIFont.preferredDateFont()
    }
    
    /**
     Styles the cells based on the values specified. The only required parameters are <code>textPlacement</code> and <code>displayStyle</code>.
     
     @param dateIsToday Bool value indicating if the date that this cell represents is today.
     @param dateIsWeekend Bool value indicating if the day that this cell represents is a weekend day.
     @param dateIsSelected Bool value indicating if the date that this cell represents is the selected date.
     @param dateIsOutsideOfMonth Bool value indicating if the date that this cell represents is outside of the current month.
     @param textPlacement Specifies the position of the text in the cell
     @param displayStyle Specifies the style of calendar that is being displayed. This will change the text size and the size of the circle that are being displayed.
    */
    func style(dateIsToday today: Bool = false, dateIsWeekend weekend: Bool = false, dateIsSelected selected: Bool = false, dateIsOutsideOfMonth outside: Bool = false, textPlacement: DateCellStyle, displayStyle: DisplayStyle) {
        // store passed in parameters
        dateIsToday = today
        dateIsWeekend = weekend
        dateIsSelected = selected
        dateIsOutsideOfMonth = outside
        self.textPlacement = textPlacement
        
        if (dateIsOutsideOfMonth) {
            // Style dates outside of the current month
            backgroundColor = CalendarDesignKit.calendarDisabledDateColor
            dateLabel.textColor = UIColor.whiteColor()
            dateLabel.alpha = 0.6
        } else {
            // Style date inside of the current month
            backgroundColor = CalendarDesignKit.dateBackgroundColor
            dateLabel.alpha = 1.0
            
            // Set text color based on selection
            if (dateIsSelected) {
                dateLabel.textColor = UIColor.whiteColor()
            } else {
                dateLabel.textColor = UIColor.blackColor()
            }
        }
        
        // Configure the placement of the text inside of the cell
        setupText(textPlacement)
        
        // Set the font and size
        switch displayStyle {
        case .InputView:
            dateLabel.font = UIFont.preferredInputViewDateFont()
        default:
            dateLabel.font = UIFont.preferredDateFont()
        }
        
        setNeedsDisplay()
    }
    
    /**
     Updates the constraints on the UILabel to position them properly.
    */
    private func setupText(placement: DateCellStyle) {
        // remove the old constraint if it exists - this could happen with cell reuse
        if let verticalConstraint = verticalConstraint {
            contentView.removeConstraint(verticalConstraint)
        }
        
        switch placement {
        case .TopCenter:
            // Pin the label to the top
            verticalConstraint = NSLayoutConstraint(item: dateLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1.0, constant: 17)
        case .CenterCenter:
            // Center the label vertically
            verticalConstraint = NSLayoutConstraint(item: dateLabel, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1.0, constant: 0)
        default: break
        }
        
        // add new constraint
        if let verticalConstraint = verticalConstraint {
            contentView.addConstraint(verticalConstraint)
        }
    }
    
    /**
     Overrid drawRect to show the circles around the date properly
    */
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // figure out the limiting dimention (height or width)
        var smallerDimension = (rect.width < rect.height ? rect.width : rect.height)
        let backgroundRect: CGRect
        
        // Figure out the background rect
        switch textPlacement {
        case .TopCenter:
            backgroundRect = CGRectMake(rect.width / 2 - smallerDimension / 2, dateLabel.frame.origin.y + (dateLabel.frame.height / 2) - smallerDimension / 2, smallerDimension, smallerDimension)
        case .CenterCenter:
            smallerDimension += 8
            backgroundRect = CGRectMake(rect.width / 2 - smallerDimension / 2, dateLabel.frame.origin.y + (dateLabel.frame.height / 2) - smallerDimension / 2, smallerDimension, smallerDimension)
        default:
            backgroundRect = CGRectMake(rect.width / 2 - smallerDimension / 2, dateLabel.frame.origin.y + (dateLabel.frame.height / 2) - smallerDimension / 2, smallerDimension, smallerDimension)
        }
        
        // Draw the circle if needed
        if (dateIsSelected) {
            CalendarDesignKit.drawSelectedBackground(backgroundRect)
        } else {
            if (dateIsToday) {
                CalendarDesignKit.drawTodayBackground(backgroundRect)
            }
        }
    }

}
