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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dateIsToday = false
        dateIsWeekend = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func style(dateIsToday today: Bool, dateIsWeekend weekend: Bool) {
        
        if (dateIsToday) {
            dateLabel.textColor = UIColor.whiteColor()
        } else {
            dateLabel.textColor = UIColor.blackColor()
        }
    }
    
//    override func drawRect(rect: CGRect) {
//        super.drawRect(rect)
//        
//        if (dateIsToday) {
//            CalendarDesignKit.drawTodayBackground(frame: rect)
//        } else {
//            if (dateIsWeekend) {
//                CalendarDesignKit.drawWeekendBackground(frame: rect)
//            } else {
//                CalendarDesignKit.drawWeekdayBackground(frame: rect)
//            }
//        }
//    }

}
