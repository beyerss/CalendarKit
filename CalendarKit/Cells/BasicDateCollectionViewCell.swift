//
//  BasicDateCollectionViewCell.swift
//  CalendarKit
//
//  Created by Steven Beyers on 5/23/15.
//  Copyright (c) 2015 Beyers Apps, LLC. All rights reserved.
//

import UIKit

internal class BasicDateCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    private var dateIsToday: Bool = false
    private var dateIsWeekend: Bool = false
    private var dateIsSelected: Bool = false
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dateIsToday = false
        dateIsWeekend = false
        dateIsSelected = false
        
        dateLabel.textColor = UIColor.blackColor()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // set background color
        backgroundColor = CalendarDesignKit.dateBackgroundColor
    }
    
    func style(dateIsToday today: Bool = false, dateIsWeekend weekend: Bool = false, dateIsSelected selected: Bool = false) {
        dateIsToday = today
        dateIsWeekend = weekend
        dateIsSelected = selected
        
        if (dateIsSelected) {
            dateLabel.textColor = UIColor.whiteColor()
        } else {
            dateLabel.textColor = UIColor.blackColor()
        }
        
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let smallerDimension = (rect.width < rect.height ? rect.width : rect.height)
        let backgroundRect = CGRectMake(rect.width / 2 - smallerDimension / 2, rect.height / 2 - smallerDimension / 2, smallerDimension, smallerDimension)
        
        if (dateIsSelected) {
            CalendarDesignKit.drawSelectedBackground(backgroundRect)
        } else {
            if (dateIsToday) {
                CalendarDesignKit.drawTodayBackground(backgroundRect)
            } else {
                CalendarDesignKit.drawDefaultBackground(backgroundRect)
            }
        }
    }

}
