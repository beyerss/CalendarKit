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
    private var horizontalConstraint: NSLayoutConstraint?
    // We need to store the text placement because it is needed everytime drawRect is called
    private var textPlacement: DateCellStyle = .TopCenter(verticalOffset: 17)
    private var circleSizeOffset: CGFloat?
    
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
        setupText(textPlacement)
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
    func style(dateIsToday today: Bool = false, dateIsWeekend weekend: Bool = false, dateIsSelected selected: Bool = false, dateIsOutsideOfMonth outside: Bool = false, textPlacement: DateCellStyle, font: UIFont, circleSizeOffset: CGFloat?) {
        // store passed in parameters
        dateIsToday = today
        dateIsWeekend = weekend
        dateIsSelected = selected
        dateIsOutsideOfMonth = outside
        self.textPlacement = textPlacement
        self.circleSizeOffset = circleSizeOffset
        
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
        dateLabel.font = font
        
        setNeedsDisplay()
    }
    
    /**
     Updates the constraints on the UILabel to position them properly.
    */
    private func setupText(placement: DateCellStyle) {
        // remove the old constraint if it exists - this could happen with cell reuse
        if let verticalConstraint = verticalConstraint, horizontalConstraint = horizontalConstraint {
            contentView.removeConstraints([verticalConstraint, horizontalConstraint])
        }
        
        switch placement {
        case .TopLeft(verticalOffset: let vOffset, horizontalOffset: let hOffset):
            verticalConstraint = makeVerticalConstraint(padding: vOffset)
            horizontalConstraint = makeHorizontalConstraint(padding: hOffset)
        case .TopCenter(verticalOffset: let offset):
            verticalConstraint = makeVerticalConstraint(padding: offset)
            horizontalConstraint = makeHorizontalConstraint(centered: true)
        case .TopRight(verticalOffset: let vOffset, horizontalOffset: let hOffset):
            verticalConstraint = makeVerticalConstraint(padding: vOffset)
            horizontalConstraint = makeHorizontalConstraint(padding: hOffset, pinnedToLeft: false)
        case .CenterLeft(horizontalOffset: let hOffset):
            verticalConstraint = makeVerticalConstraint(centered: true)
            horizontalConstraint = makeHorizontalConstraint(padding: hOffset)
        case .CenterCenter:
            verticalConstraint = makeVerticalConstraint(centered: true)
            horizontalConstraint = makeHorizontalConstraint(centered: true)
        case .CenterRight(horizontalOffset: let hOffset):
            verticalConstraint = makeVerticalConstraint(centered: true)
            horizontalConstraint = makeHorizontalConstraint(padding: hOffset, pinnedToLeft: false)
        case .BottomLeft(verticalOffset: let vOffset, horizontalOffset: let hOffset):
            verticalConstraint = makeVerticalConstraint(padding: vOffset, pinnedToTop: false)
            horizontalConstraint = makeHorizontalConstraint(padding: hOffset)
        case .BottomCenter(verticalOffset: let vOffset):
            verticalConstraint = makeVerticalConstraint(padding: vOffset, pinnedToTop: false)
            horizontalConstraint = makeHorizontalConstraint(centered: true)
        case .BottomRight(verticalOffset: let vOffset, horizontalOffset: let hOffset):
            verticalConstraint = makeVerticalConstraint(padding: vOffset, pinnedToTop: false)
            horizontalConstraint = makeHorizontalConstraint(padding: hOffset, pinnedToLeft: false)
        }
        
        // add new constraint
        if let verticalConstraint = verticalConstraint, horizontalConstraint = horizontalConstraint {
            contentView.addConstraints([verticalConstraint, horizontalConstraint])
        }
    }
    
    private func makeVerticalConstraint(padding padding: CGFloat = 0.0, centered: Bool = false, pinnedToTop: Bool = true) -> NSLayoutConstraint {
        if (centered) {
            return NSLayoutConstraint(item: dateLabel, attribute: .CenterY, relatedBy: .Equal, toItem: contentView, attribute: .CenterY, multiplier: 1.0, constant: 0)
        } else {
            if (pinnedToTop) {
                return NSLayoutConstraint(item: dateLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1.0, constant: padding)
            } else {
                return NSLayoutConstraint(item: contentView, attribute: .Bottom, relatedBy: .Equal, toItem: dateLabel, attribute: .Bottom, multiplier: 1.0, constant: padding)
            }
        }
    }
    
    private func makeHorizontalConstraint(padding padding: CGFloat = 0.0, centered: Bool = false, pinnedToLeft: Bool = true) -> NSLayoutConstraint {
        if (centered) {
            return NSLayoutConstraint(item: dateLabel, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1.0, constant: 0)
        } else {
            if (pinnedToLeft) {
                return NSLayoutConstraint(item: dateLabel, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1.0, constant: padding)
            } else {
                return NSLayoutConstraint(item: contentView, attribute: .Right, relatedBy: .Equal, toItem: dateLabel, attribute: .Right, multiplier: 1.0, constant: padding)
            }
        }
    }
    
    /**
     Overrid drawRect to show the circles around the date properly
    */
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // figure out the limiting dimention (height or width)
        var smallerDimension = (bounds.width < bounds.height ? bounds.width : bounds.height)
        
        // change the smallerDimension if the circle size is setup to be changed in the config
        if let circleSizeOffset = circleSizeOffset {
            smallerDimension += circleSizeOffset
        }
        
        // frame of date text
        let dateFrame = dateLabel.frame
        
        let backgroundRect = CGRectMake(dateFrame.origin.x + (dateFrame.width / 2) - (smallerDimension / 2), dateFrame.origin.y + (dateFrame.height / 2) - (smallerDimension / 2), smallerDimension, smallerDimension)
        
        // Draw the circle if needed
        if (dateIsSelected) {
            CalendarDesignKit.drawSelectedBackground(frame: backgroundRect)
        } else {
            if (dateIsToday) {
                CalendarDesignKit.drawTodayBackground(frame: backgroundRect)
            }
        }
    }

}
