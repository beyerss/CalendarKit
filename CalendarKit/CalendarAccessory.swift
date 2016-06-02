//
//  CalendarAccessory.swift
//  CalendarKit
//
//  Created by Steven Beyers on 6/2/16.
//  Copyright © 2016 Beyers Apps, LLC. All rights reserved.
//

import Foundation

public struct CalendarAccessory {
    
    let placement: ViewPlacement
    let view: UIView
    
    public init(placement: ViewPlacement, view: UIView) {
        self.placement = placement
        self.view = view
    }
    
}