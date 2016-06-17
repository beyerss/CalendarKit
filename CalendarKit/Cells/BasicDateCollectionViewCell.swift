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
    private var disabled: Bool = false
    private var verticalConstraint: NSLayoutConstraint?
    private var horizontalConstraint: NSLayoutConstraint?
    // We need to store the text placement because it is needed everytime drawRect is called
    private var textPlacement: ViewPlacement = .topCenter(verticalOffset: 17)
    private var circleSizeOffset: CGFloat?
    var circleColor: UIColor?
    
    // Accessory view
    var accessory: CalendarAccessory?
    
    // Text colors
    var highlightedTextColor = UIColor.black().withAlphaComponent(0.3)
    var selectedTextColor = UIColor.white()
    var disabledTextColor = UIColor.white().withAlphaComponent(0.6)
    var enabledTextColor = UIColor.black()
    
    /**
     Updates the dateLabel text so indicate when the cell was selected
    */
    override var isHighlighted: Bool {
        didSet {
            if (!disabled) {
                if (isHighlighted) {
                    dateLabel.textColor = highlightedTextColor
                } else {
                    dateLabel.textColor = enabledTextColor
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // reset defaults
        dateIsToday = false
        dateIsWeekend = false
        dateIsSelected = false
        
        dateLabel.textColor = enabledTextColor
        
        // If there was an accessory, remove it
        if let accessory = accessory {
            accessory.view.removeFromSuperview()
        }
        accessory = nil
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
    func style(dateIsToday today: Bool = false, dateIsWeekend weekend: Bool = false, dateIsSelected selected: Bool = false, disabled: Bool = false, textPlacement: ViewPlacement, font: UIFont, circleSizeOffset: CGFloat?, calendarConfiguration: CalendarConfiguration?, accessory: CalendarAccessory?) {
        // store passed in parameters
        dateIsToday = today
        dateIsWeekend = weekend
        dateIsSelected = selected
        self.disabled = disabled
        self.textPlacement = textPlacement
        self.circleSizeOffset = circleSizeOffset
        
        if (disabled) {
            // Style dates outside of the current month
            if let config = calendarConfiguration?.dateCellConfiguration {
                backgroundColor = config.disabledBackgroundColor
            } else {
                backgroundColor = CalendarDesignKit.calendarDisabledDateColor
            }
            dateLabel.textColor = disabledTextColor
        } else {
            // Style date inside of the current month
            if let config = calendarConfiguration?.dateCellConfiguration {
                backgroundColor = config.backgroundColor
            } else {
                backgroundColor = CalendarDesignKit.dateBackgroundColor
            }
            
            // Set text color based on selection
            if (dateIsSelected) {
                dateLabel.textColor = selectedTextColor
            } else {
                dateLabel.textColor = enabledTextColor
            }
        }
        
        // Configure the placement of the text inside of the cell
        setupText(textPlacement)
        
        // Set the font and size
        dateLabel.font = font
        
        // set up the accessory
        setupAccessory(accessory)
        
        setNeedsDisplay()
    }
    
    /**
     Updates the constraints on the UILabel to position them properly.
    */
    private func setupText(_ placement: ViewPlacement) {
        // remove the old constraint if it exists - this could happen with cell reuse
        if let verticalConstraint = verticalConstraint, horizontalConstraint = horizontalConstraint {
            contentView.removeConstraints([verticalConstraint, horizontalConstraint])
        }
        
        let newConstraints = makeConstraints(forView: dateLabel, withPlacement: placement)
        verticalConstraint = newConstraints.verticalConstraint
        horizontalConstraint = newConstraints.horizontalConstraint
        
        // add new constraint
        if let verticalConstraint = verticalConstraint, horizontalConstraint = horizontalConstraint {
            contentView.addConstraints([verticalConstraint, horizontalConstraint])
        }
    }
    
    /**
     Sets up the accessory if there is one
    */
    private func setupAccessory(_ accessory: CalendarAccessory?) {
        guard let accessory = accessory else { return }
        
        // keep track of the accessory for cell re-use
        self.accessory = accessory
        
        accessory.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(accessory.view)
        
        let accessoryConstraints = makeConstraints(forView: accessory.view, withPlacement: accessory.placement)
        contentView.addConstraint(accessoryConstraints.verticalConstraint)
        contentView.addConstraint(accessoryConstraints.horizontalConstraint)
    }
    
    private func makeConstraints(forView view: UIView, withPlacement placement: ViewPlacement) -> (verticalConstraint: NSLayoutConstraint, horizontalConstraint: NSLayoutConstraint) {
        let vConstraint: NSLayoutConstraint
        let hConstraint: NSLayoutConstraint
        
        switch placement {
        case .topLeft(verticalOffset: let vOffset, horizontalOffset: let hOffset):
            vConstraint = makeVerticalConstraint(forView: view, padding: vOffset)
            hConstraint = makeHorizontalConstraint(forView: view, padding: hOffset)
        case .topCenter(verticalOffset: let offset):
            vConstraint = makeVerticalConstraint(forView: view, padding: offset)
            hConstraint = makeHorizontalConstraint(forView: view, centered: true)
        case .topRight(verticalOffset: let vOffset, horizontalOffset: let hOffset):
            vConstraint = makeVerticalConstraint(forView: view, padding: vOffset)
            hConstraint = makeHorizontalConstraint(forView: view, padding: hOffset, pinnedToLeft: false)
        case .centerLeft(horizontalOffset: let hOffset):
            vConstraint = makeVerticalConstraint(forView: view, centered: true)
            hConstraint = makeHorizontalConstraint(forView: view, padding: hOffset)
        case .centerCenter:
            vConstraint = makeVerticalConstraint(forView: view, centered: true)
            hConstraint = makeHorizontalConstraint(forView: view, centered: true)
        case .centerRight(horizontalOffset: let hOffset):
            vConstraint = makeVerticalConstraint(forView: view, centered: true)
            hConstraint = makeHorizontalConstraint(forView: view, padding: hOffset, pinnedToLeft: false)
        case .bottomLeft(verticalOffset: let vOffset, horizontalOffset: let hOffset):
            vConstraint = makeVerticalConstraint(forView: view, padding: vOffset, pinnedToTop: false)
            hConstraint = makeHorizontalConstraint(forView: view, padding: hOffset)
        case .bottomCenter(verticalOffset: let vOffset):
            vConstraint = makeVerticalConstraint(forView: view, padding: vOffset, pinnedToTop: false)
            hConstraint = makeHorizontalConstraint(forView: view, centered: true)
        case .bottomRight(verticalOffset: let vOffset, horizontalOffset: let hOffset):
            vConstraint = makeVerticalConstraint(forView: view, padding: vOffset, pinnedToTop: false)
            hConstraint = makeHorizontalConstraint(forView: view, padding: hOffset, pinnedToLeft: false)
        }
        
        return (vConstraint, hConstraint)
    }
    
    private func makeVerticalConstraint(forView view: UIView, padding: CGFloat = 0.0, centered: Bool = false, pinnedToTop: Bool = true) -> NSLayoutConstraint {
        if (centered) {
            return NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0)
        } else {
            if (pinnedToTop) {
                return NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: padding)
            } else {
                return NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: padding)
            }
        }
    }
    
    private func makeHorizontalConstraint(forView view: UIView, padding: CGFloat = 0.0, centered: Bool = false, pinnedToLeft: Bool = true) -> NSLayoutConstraint {
        if (centered) {
            return NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0)
        } else {
            if (pinnedToLeft) {
                return NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1.0, constant: padding)
            } else {
                return NSLayoutConstraint(item: contentView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: padding)
            }
        }
    }
    
    /**
     Overrid drawRect to show the circles around the date properly
    */
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // figure out the limiting dimention (height or width)
        var smallerDimension = (bounds.width < bounds.height ? bounds.width : bounds.height)
        
        // change the smallerDimension if the circle size is setup to be changed in the config
        if let circleSizeOffset = circleSizeOffset {
            smallerDimension += circleSizeOffset
        }
        
        // frame of date text
        let dateFrame = dateLabel.frame
        
        let backgroundRect = CGRect(x: dateFrame.origin.x + (dateFrame.width / 2) - (smallerDimension / 2), y: dateFrame.origin.y + (dateFrame.height / 2) - (smallerDimension / 2), width: smallerDimension, height: smallerDimension)
        
        // Draw the circle if needed
        if (dateIsSelected) {
            if let circleColor = circleColor {
                CalendarDesignKit.drawCircleFilledBackground(frame: backgroundRect, dateCircleColor: circleColor)
            } else {
                CalendarDesignKit.drawCircleFilledBackground(frame: backgroundRect)
            }
        } else {
            if (dateIsToday) {
                if let circleColor = circleColor {
                    CalendarDesignKit.drawCircleBackground(frame: backgroundRect, dateCircleColor: circleColor)
                } else {
                    CalendarDesignKit.drawCircleBackground(frame: backgroundRect)
                }
            }
        }
    }

}
