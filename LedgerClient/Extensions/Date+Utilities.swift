//
//  Date+Utilities.swift
//  LedgerClient
//
//  Created by Johannes on 24.12.17.
//  Copyright © 2017 Johannes Raufeisen. All rights reserved.
//

import UIKit

extension Date {
    
    /*
    *   Returns the first day of the current month
    */
    func firstDayOfCurrentMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
        
    }
}
