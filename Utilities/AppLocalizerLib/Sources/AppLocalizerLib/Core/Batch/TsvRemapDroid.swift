//
//  TsvRemapDroid.swift
//  AppLocalizerLib
//
//

import Foundation

struct TsvRemapDroid {

    static let check = TsvRemapDroid()
    // 
    var dropSet: Set<String>
    var replaceDict: [String: String]
    
    init() {
        dropSet = Set<String>()
        replaceDict = [String: String]()
    }
    
    func isDropped(_ key: String) -> Bool {
        return dropSet.contains(key)
    }

    func isReplaced(_ key: String) -> String? {
        return replaceDict[key]
    }
}
