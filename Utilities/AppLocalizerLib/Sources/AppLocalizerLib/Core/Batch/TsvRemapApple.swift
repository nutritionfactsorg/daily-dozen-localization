//
//  TsvRemapApple.swift
//  AppLocalizerLib
//
//

import Foundation

struct TsvRemapApple {

    static let check = TsvRemapApple()
    // 
    private var dropSet: Set<String>
    private var replaceDict: [String: String]
    
    init() {
        dropSet = Set<String>()
        dropSet.insert("OC8-wt-JgC.normalTitle") // "dateButtonTitle.today"
        dropSet.insert("iHh-5a-01X.normalTitle") // "dateButtonTitle.today"
        dropSet.insert("OIQ-oh-3QN.normalTitle") // "dateBackButtonTitle"
        dropSet.insert("Qfe-bW-SP4.normalTitle") // "dateBackButtonTitle"
        
        // Use key sort order 09AZaz to replace first instance
        // of multi-instance key group
        replaceDict = [String: String]()
        replaceDict["6FY-X2-BdZ.normalTitle"] = "dateButtonTitle.today"
        replaceDict["7XY-Lo-Hwf.normalTitle"] = "dateBackButtonTitle"
    }
    
    func isDropped(_ key: String) -> Bool {
        return dropSet.contains(key)
    }
    
    func isReplaced(_ key: String) -> String? {
        return replaceDict[key]
    }
    
}
