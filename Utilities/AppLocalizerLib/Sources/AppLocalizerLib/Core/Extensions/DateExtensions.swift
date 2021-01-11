//
//  DateExtensions.swift
//
//  Copyright © 2020 Nutritionfacts.org. All rights reserved.
//

import Foundation

public extension Date {
    
    /// Return yyyyMMdd based on the current locale.
    static var datestampyyyyMMdd: String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: now)
    }
        
    static var datestampyyyyMMddHHmm: String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmm"
        return dateFormatter.string(from: now)
    }
    
    static var datestampyyyyMMddHHmmssSSS: String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss.SSS"
        return dateFormatter.string(from: now)
    }
}
