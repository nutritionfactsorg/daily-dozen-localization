//
//  DateExtensions.swift
//
//  Copyright © 2020 Nutritionfacts.org. All rights reserved.
//

import Foundation

public extension Date {
    
    /// Return yyyyMMdd based on the current locale.
    var datestampyyyyMMdd: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: self)
    }
        
    var datestampyyyyMMddHHmm: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmm"
        return dateFormatter.string(from: self)
    }
    
    var datestampyyyyMMddHHmmssSSS: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss.SSS"
        return dateFormatter.string(from: self)
    }
}
