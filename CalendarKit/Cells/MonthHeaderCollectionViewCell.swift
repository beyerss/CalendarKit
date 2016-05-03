//
//  MonthHeaderCollectionViewCell.swift
//  CalendarKit
//
//  Created by Steven Beyers on 4/29/16.
//  Copyright © 2016 Beyers Apps, LLC. All rights reserved.
//

import UIKit

class MonthHeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var monthName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set default font style
        monthName.font = UIFont.preferredMonthHeaderFont()
    }

}
